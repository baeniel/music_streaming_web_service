class ApplicationController < ActionController::Base
  helper_method :add_playlists
  before_action :configure_permitted_parameters, if: :devise_controller?

  def add_playlists(music_ids, group_id)
    group = Group.find group_id
    # n개 추가
    if music_ids.length > 1
      AddGroupPlaylistRecordsJob.perform_async(music_ids, current_user.email, group.id)
    # 1개 추가
    else
      music = Music.find music_ids.join(",")
      GroupMusic.create(group: group, music: music, user: current_user)
      CheckGroupPlaylistRecordsJob.perform_async(group.id)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_in, keys: [:email, :password]
    devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :password_confirmation]
  end
end
