class DownloadFileWorker
  include Sidekiq::Worker

  # DownloadFileWorker.perform_async(url, directory, filename)
  def perform(url, directory, filename)
    Crawler.download_file(url, directory, filename)
  end
end
