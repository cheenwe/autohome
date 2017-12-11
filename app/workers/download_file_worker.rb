class DownloadFileWorker
  include Sidekiq::Worker

  # DownloadFileWorker.perform_async('bob', 5)
  def perform(person_id)
    # Do something
    Person.find(person_id).write_pic_file rescue ''
  end
end
