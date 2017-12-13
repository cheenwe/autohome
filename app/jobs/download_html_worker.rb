class DownloadHtmlWorker
  include Sidekiq::Worker

  # DownloadHtmlWorker.perform_async(url, filename)
  def perform(url, filename)
    Car.new.down_file(url, filename)
  end
end
