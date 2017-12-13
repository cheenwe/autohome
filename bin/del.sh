
# current_file_path="/Users/chenwei/workspace/project/autohome/tmp/html"


# # function changeName(){
# #   sed '26,80d' $1 > file.copy
# #   mv file.copy $1
# # }



# file="/Users/chenwei/workspace/project/autohome/tmp/test_2.html"

# changeName $file


current_file_path="/Users/chenwei/workspace/project/autohome/tmp/photos"



function changeName(){
  sed '6d;27,81d;86,136d'  $1 > file.copy
  mv file.copy $1
}

for shname in `ls $current_file_path`

do

  flist=`ls  $current_file_path/$shname`
    #echo $flist
    for f in $flist
    do
      echo $current_file_path/$shname/$f

      changeName $current_file_path/$shname/$f
    done

done



