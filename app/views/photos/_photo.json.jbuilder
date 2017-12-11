json.extract! photo, :id, :car_id, :name, :image, :photo, :color, :background, :price, :remark, :created_at, :updated_at
json.url photo_url(photo, format: :json)
