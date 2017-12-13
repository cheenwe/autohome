class ParsePhotoHtmlWorker
  include Sidekiq::Worker

  # ParsePhotoHtmlWorker.perform_async(id, filename)
  def perform(id, filename)
    Crawler.new.deal_photo_file(id, filename)
  end
end
