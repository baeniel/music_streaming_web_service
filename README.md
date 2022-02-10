# 링글 과제

### 1. 실행방법
```ShellSession
$ rails db:seed
```
seed파일을 실행해주시면, 공공API에서 가져온 한국저작권보호원 음악 저작물 약 1600개와 test user들이 생성됩니다.<br><br>

### 2. Postgresql을 사용한 이유
처음에는 Mysql을 사용했습니다. 하지만, 검색 기능 구현 후 index를 사용하기 위해 아래와 같은 코드를 추가했지만 계속 Full scan을 하는 문제가 있었습니다. Possible_keys로 music_index를 사용할 수 있음에도 불구하고 계속 사용하지 않는 것입니다.
```ShellSession
$ add_index :musics, [:title, :album_name, :artist_name], name: "music_index"
```
따라서 다른 DB에서는 어떤지 테스트가 필요했고, 마침 아래와 같은 블로그를 발견하고 psql을 사용하게 되었습니다. 복잡한 쿼리나 대규모 서비스에서 mysql보다 더 적합하다고 생각했기 때문입니다. <br><br>
참고: [https://techblog.woowahan.com/6550/] <br><br>

### 3. pg_search gem을 사용한 이유
처음에는 ransack gem을 사용했습니다. ransack은 예전에도 사용해 본 경험이 있었을 뿐더러, star의 갯수도 많았고 무엇보다 구현이 쉬웠습니다. 그러나 시드 데이터 삽입 후 '아이유'와 같은 검색을 수행한 결과 '(feat. 아이유)'와 경우는 cont matcher를 사용했음에도 불구하고 검색 결과에 포함되지 않는 것을 발견했습니다. <br><br>또한 '아이유', '좋은 날' 등 검색 키워드를 음악명, 가수명 등의 한 가지 기준으로 검색하기보다 '가수명(아이유) + 음악명(좋은 날)', '음악명(좋은 날) + 앨범명(조각집)' 등 다양하게 조합해서 검색을 하는 경우가 실생활에 더 많을 것이라고 생각했습니다. 이런 상황에 대비하기 위해서는 split을 사용한 별도의 작업이 필요했습니다. <br><br>
따라서 ransack으로는 한계가 있다고 결론을 내리고 psql의 pg_trgm이나 Full Text Search 등의 유용한 기능들을 rails에서 쉽게 쓸 수 있는 pg_search gem을 사용하게 됐습니다. <br><br>

### 4. 검색 세부 설정
'음악명 + 가수명 + 앨범명' 등과 같이 여러가지 단어의 조합으로 검색을 할 수 있는 상황에서 이것을 각각 Like query로 처리하기 보다는 pg_trgm이나 Full Text Search를 사용하는 것이 더 효율적이라는 생각을 했습니다.<br><br>
pg_trgm의 경우 단어의 유사성을 바탕으로 문법의 오류 등을 보정해주는 유용한 기능이 있지만, 한 가지 단어가 아니라 여러 가지 단어의 조합으로 검색을 시행했을 경우엔 효율적인 검색이 어려워보였습니다. 따라서 FTS를 사용하게 됐습니다.

```ShellSession
$ Music.distinct.count(:title)
```
또한, 위와 같은 코드로 각각의 unique한 값의 갯수를 찾아보니 title, album_name, artist_name 순으로 cardinality가 높았기에 가중치를 이 순서대로 설정했습니다. <br><br>

### 5. 인덱스 설정
FTS를 적용하고 쿼리를 조회해본 결과 쿼리가 실행될 때마다 to_tsvector function이 실행되는 것을 발견했습니다. 이를 미리 tsvector로 계산시켜놓고 실제 column에 저장해 놓는다면 보다 효율적으로 FTS를 실행할 수 있다는 것을 알게 되었습니다. 따라서 가중치를 설정한 순서대로 SQL문을 migration 해 주었습니다. <br><br>
![56EBACD8-45EB-4B43-8EFA-D22A7FDE2225_1_105_c](https://user-images.githubusercontent.com/54925880/153354318-87ea44a5-d7ce-4e50-ae1a-d976e70f3008.jpeg)<br><br>
그리고, 이렇게 추가된 searchable 컬럼에 rapid matching을 용이하게 하는 등의 기능을 가짐으로써 FTS에 적합한 GIN 인덱스를 추가했습니다. 마지막으로 인덱스를 만드는 도중에는 write가 locking되는 것을 방지하기 위해 concurrently를 추가했습니다.
```ShellSession
$ add_index :musics, :searchable, using: :gin, algorithm: :concurrently
```
그 결과, 음원 데이터 약 50만건에서 '아이유'를 검색했을 때 아래와 같이 cost가 181,098이었던 과거와 다르게 <br><br>
![08634DE2-FCB7-419E-BC63-ACBA6C8FAF5C_1_201_a](https://user-images.githubusercontent.com/54925880/153355207-3015c374-aab2-47fb-ae3e-a2c70ab897ea.jpeg)<br><br>
cost가 28,444로 약 6.5배 정도 빨라진 것을 확인할 수 있었습니다. <br><br>
![스크린샷 2022-02-10 16 06 06](https://user-images.githubusercontent.com/54925880/153359964-35a19095-6cf2-469f-bffa-5944fc29bb54.jpeg)
<br><br>

### 6. 사이드킥을 사용한 이유
개인 재생목록과 그룹 재생목록을 n건 이상 추가, 삭제하는 경우 sidekiq으로 비동기화 작업을 실행시켰습니다. 과제에서는 재생목록이 100개로 제한되어 있지만, 실제 서비스의 경우 수백건의 재생목록도 한꺼번에 삭제시키는 사례가 있을 수 있다고 생각했기 때문에 해당 작업을 컨트롤러에서 처리하면 작업이 끝날 때까지 유저는 다른 액션을 취하지 못하는 문제가 발생할 수 있다고 생각했습니다.<br><br>

### 7. 추가 기능 구현 목록
1. 좋아요 추가, 삭제 ajax 처리
2. 마이페이지 UI 및 마이페이지에서 듣기, 담기 (+전체선택 / 해제) 가능하게
3. 그룹 삭제 API
4. devise error 처리<br><br>

### 8. 아쉬운 점
대용량 데이터를 가진 환경에서의 서비스를 한번도 설계해본 적이 없었기 때문에 db 선택, 인덱싱 방법 등에서 생각보다 많은 시행착오를 겪었습니다. 원래는 다른 유저에게 그룹에 참여하라는 초대 메세지를 보내고 이를 수락 / 거부하는 기능, 같은 그룹 안에서의 다른 유저의 플레이리스트를 엿보는 기능 등도 구현할 예정이었으나 시간이 넉넉하지 못해 구현하지 못했습니다. 하나의 서비스를 전체적인 개발의 관점에서 조목조목 따져볼 수 있는 좋은 기회 주셔서 감사합니다.
