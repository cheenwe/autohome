# 汽车之家车型及图片数据爬取

爬取网络上明星数据

品牌
brands
name:string
english_name:string
abbr:string
logo:string
remark:string

cars

brand_id:integer
sub_barnd:string
price:string
remark:string

car_photos

car_id:integer
name:string
image::string
photo:string
color:string
background:string
price:string

rails g scaffold name:string english_name:string abbr:string  logo:string remark:string

rails g scaffold brand_id:integer sub_barnd:string price:string remark:string

rails g scaffold car_id:integer name:string image::string photo:string color:string background:string price:string  remark:string

#F6F6F6



## work

>rails g sidekiq:worker download_file