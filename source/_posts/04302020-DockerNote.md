---
title: DockerNote
categories: Container
tags:
  - Container
  - Docker
  - K8s
abbrlink: b53499ee
u`pdated: 2020-05-17 21:39:55
date: 2020-04-30 07:48:09
---
Docker and Kubernetes note
<!-- more -->

## App note
下面是开发时需要用到的环境配置, 从最底层
os:
input method: sougou/fcitx
xmonad/amethyst
autohotKey karabiner/cmder/Context schroo/listary/
fish shell
...

init:
vim  .vimrc
git   username, email
jdk   path
maven  settings
idea   ideaSettings or ideaConfig dir

container(docker):
mysql/oracle
redis
rocketMQ
tomcat

## Mariadb
按照docker hub上的文档说明启动容器，需要加上端口映射 -p 3306:3306
```txt
docker run --name mydb -v /Users/wutaotao/stuff/mysqlData:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=xxx -p 3306:3306 -d mariadb
```

## oracle
docker hub和github上的image都可以使用，按对应文档启动容器即可。
```txt
docker hub
docker run -d -it --name oracle -v /Users/wutaotao/stuff/oracleData:/ORCL -p 1521:1521 -p 5500:5500 store/oracle/database-enterprise:12.2.0.1

quay.io/maksymbilenko/oracle-12c github
docker run -d -p 1521:1521 -v /Users/wutaotao/stuff/oracleData/:/u01/app/oracle quay.io/maksymbilenko/oracle-12c
```

## mongodb
```txt
docker pull mongo
docker run --name mongo -p 27017:27017 -v /Users/wutaotao/stuff/mongodb:/data/db -d mongo --auth

// enter into container
docker exec -it mongo /bin/bash
mongo   //or mongo --port 27017  

// create admin
use admin
db.createUser(
  {
    user: "admin",
    pwd: passwordPrompt(), // or cleartext password
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
  }
)
exit   // exit mongo shell
mongo -u 'admin' -p 'admin' --authenticationDatabase 'admin'
// or auth after connected 
mongo
use admin  // change database
show dbs  // nothing
db.auth('admin', 'admin')
show dbs  // successfully show dbs

// add extra user wtt with auth to database vue
ues vue
db.createUser(
  {
    user: "wtt",
    pwd:  passwordPrompt(),   // or cleartext password
    roles: [{ role: "readWrite", db: "vue" }]
  }
)
exit
docker exec -it mongo mongo -u 'wtt' -p 'wtt' --authenticationDatabase 'vue'


mongo university atlas learning cluster
docker exec -it mongo mongo "mongodb+srv://cluster0-jxeqq.mongodb.net/test" --username m001-student -password m001-mongodb-basics

atlas 是数据库服务平台，多个服务实例复制相同的数据实现可用性，每个集群只有一个主服务.
database - collection
database.collection 构成了命名空间 
这里感觉collection和表的概念差不多，后面再验证

show dbs
use video
show collections  -- collectionName is movies
db.movies.find().pretty()   -- db.collectionName.find().pretty()

create atlas account and use free tier
all ip whitelist and database users(admin rights)
download the load.js file
move the load.js file to the host mongodb directory for docker to use, inside
mongo container the mapped location(as above commannd) is /data/db

docker exec -it mongo /bin/bash
mv /db/load.js /home/
mongo "mongodb+srv://sandbox-pbr9e.mongodb.net/test" --username wtt 
enter password  (ignore log warn)
load('/home/load.js')   // return true

use video
create collection test in compass
db.test.insertOne({name: 'wtt', age: 30, salary: 2333.44})
//  `each _id value is unique in each collection, like table primary key`
// default ordered is true, so when error reported, mongodb will not insert any more
`db.test.insertMany([{_id: '001',name: 'wtt', age: 30, salary: 2333.44},
{_id: '001',name: 'wtt', age: 30}, {name: 'test'}])`

// when ordered is false, it will insert any data that is good
`db.test.insertMany([{_id: '001',name: 'wtt', age: 30, salary: 2333.44},
{_id: '001',name: 'wtt', age: 30}, {name: 'test'}], {ordered: false})`

query
db.collectionName.find().pretty()
db.collectionName.find({'name': 'wtt'}).pretty()
// hierarchical query using dot notation and quote the key to query
db.collectionName.find({'wind.direction.angle': 999}).pretty()

lab answer:
db.movieDetails.find({'awards.wins': 2, 'awards.nominations': 2}).count()
db.movieDetails.find({'rated': 'PG', 'awards.nominations': 10}).count()

**mongo shell: ctrl + u is clearing the input text**
**mongodb中document和object是相同的意思，即文档类型就是Object对象类型**

array query
// match the whole array
db.coll.find({'array': ['a', 'b']}).pretty()

// match one of the array elements, with a included
db.coll.find({'array': 'a'}).pretty()

// match a at the specific position
db.coll.find({'array.1': 'a'}).pretty()

find()方法返回的是一个迭代器, mongo shell中默认每次迭代展示20条记录
find()方法可以传递第二个参数，对返回的结果集中的字段进行限定，类似select语句的限定字段，
它叫projection, 值为0代表不包含，1代表包含, `_id`默认是包含的
`db.coll.find({'array.1': 'a'}, {title: 1, _id: 0}).pretty()`

updateOne
db.coll.updateOne({
  title: 'test'
}, {
  $set: {user: 'ss'}
})
// updateOne will update only the first record matching the title = test, usually we
pass the `_id` to get the only one record needed to be update once.
// the second argument is the newItem, it will add new field if the old one do not exist
or update the old field if it existed

update other operators

// $set   update or add fields
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $set: {
       updateBy: 'wtt',
       updateTime: '20200518'
      } 
  })

// unset     remove fields, value can be anything, do not matter
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $unset: {
       updateBy: 'xx',
       updateTime: 'xx'
      } 
  })

// $rename  rename fields name
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $rename: {
       updateBy: 'newUpdate',
       updateTime: 'newUpdateTime'
      } 
  })
// $inc $max $min $mul   used for numeric field values to increase some number
// or get the maxValue of the old, new one,  get the minValue of the old, new one
// multiply the value by set value

// $currentDate
// the result gets updateBy: ISODate("2020...")
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $currentDate: {
       updateBy: true,
       updateTime: true
      } 
  })
// this gets the same result
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $currentDate: {
       updateBy: {$type: 'date'},
       updateTime: {$type: 'date'}
      } 
  })
// this gets timeStamp result
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $currentDate: {
       updateBy: {$type: 'timestamp'},
       updateTime: {$type: 'timestamp'}
      } 
  })

// array
// **mongodb 作用最大的树级结构数据存储，嵌套属性是必须的，所以array update 操作符很实用**
// push to an  array, it will create the array field if not existed
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $push: {
      myArr: {
        name: 'wtt',
        age: 30,
        sex: 'M'
      }
    }
  })
// push many items once to an array
// using $each modifier, its value is an array below
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $push: {
      myArr: {
        $each: [
          {
            name: 'wtt',
            age: 30,
            sex: 'M'
          }, 
          {
            name: 'cll',
            age: 27,
            sex: 'F'
          }, 
          {
            name: 'wwt',
            age: 25,
            sex: 'M'
          }
        ]
      }
    }
  })

// pop  pop expects 1 or -1
// 1 means the last item, -1 means the first item
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $pop: {
      myArr: -1
    }
  })

// $pull
// remove all items of myArr whose sex is M
// pull use query condition
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $pull: {
      myArr: {
        "sex": "M"
      }
    }
  })

// $pullAll remove items in a list from an array
// useful with repeated elements in an array
db.movieDetails.updateOne({
   title: 'Star Trek'
  }, {
    $pullAll: {
      myArr: [{...}, {...}]
    }
  })

// updateMany
// batch update many documents
db.movieDetails.updateMany({
  "awards.wins": 2
   }, {
  $inc: {
     "awards.wins": 1
  }
})
// upset
// 类似saveOrUpdate, 条件不满足时新增document
db.movieDetails.updateOne({
   "id": detail.id
}, {
      $set: detail
}, {
    upsert: true
})

**mongo shell实际上是js解析器，同console类似，可以在上面执行js语句**
// replaceOne命令与updateOne类似，但它替换的是整个匹配到的document对象
let filter = {title: 'Wild Wild West'}
let doc = db.movieDetails.findOne(filter)   // 不能使用find()方法
doc.updatedBy = 'wtt'
db.movieDetails.replaceOne(filter, doc)   // update succeed

// deleteOne
// deleteMany

query operators
$eq $gt $gte $lt $lte  $ne(not equal include field do not exist at all)
$in $nin(the value type is an array)

// use $in to judge the array contains a or b
db.movieDetails.find({writers: {$in: ['a', 'b']}}).count()
// arrayName: [] match the overall array, and arrayName: {} judges the array elements

//element query operators
$exists   filter a field exists in documents  {name: {$exists: true}}
$type   filter a specific type field in documents  {name: {$type: bool}}
// {name: null} will get the null value field documents and non-existed field documents

//logical operators
$or   selectors only need one is true, value is an array, contains all selectors
     db.test.find({$or: [{'sex': 'm'}, {'age': 30}]})  // sex is man or age = 30

$and   because filtors are default and, so $and is used for same field name needing to be used
      more than once:
        db.test.find({$and: [{'name': {$ne: null}}, {'name': {exists: true}}]})
         //  find documents whose name value is not null and does exist

// array operators
$all  {arrayName: {$all: ['b', 'c']}}
  // need the array contains b and c element

$size  {arrayName: {$size: 2}}
  // match the array whose size is 2

$elemMatch  
    // this query only need the array contains an item whose name = wtt, and contais
    // another item's age = 30, do not need to be the same item
   db.test.find({arrayName: {'name': 'wtt', 'age': 30}})

   // when we need the same item to be matched, use $elemMatch
   // $elemMatch match for one item, so it uses {}(like document) to get result
   db.test.find({arrayName: {$elemMatch: {'name': 'wtt', 'age': 30}}})

$regex
   // 想想可以在sql中使用正则表达式！
   // mysql  regexp 关键字(同like类似)
   // `select * from my_user where name regexp '^[0-9]{3}$'`
   // oracle中有`regexp_like, regexp_instr, regexp_substr, regexp_replace`关键字
   // use regular expression for text string match
可以写为 db.test.find({name: {$regex: 'pattern', $options: 'options'}})
或 db.test.find({name: {$regex: /pattern/options}})
或最简单实用的 直接省略$regex关键字
db.test.find({name: /pattern/options})  
  //在某些场景下必须使用$regex或必须使用/pattern/语法, 具体见文档


   




```

## ubuntu in docker
1. docker pull ubuntu   // 现在默认是20.04 LTS版本
2. docker run --name ubuntu -v /Users/wutaotao/stuff/ubuntu/:/home/ \
 -it -e LANG=C.UTF-8 -e LC_ALL=C.UTF-8 ubuntu 
3. apt update
4. apt install vim
5. cp /etc/apt/sources.lst /etc/apt/sources.lst.bak
   vim /etc/apt/sources.list
   // 20.04的源
```txt
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
```
6. apt install git curl 
7. adduser tao
8. apt install sudo -y
9. passwd  // change root user passwd
9. `echo "Set disable_coredump false" >> /etc/sudo.conf`  // fix the sudo warning bug  
9. su - tao
10. sudo ls   // check sudo command, first time need to input password 
11. git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
12. copy .vimrc
13. :PluginInstall 
14. sudo apt install fcitx fcitx-pinyin  // need gui to config fcitx, let's do this!
15. in mac terminal:(version 10.15.2 catalina)
```txt
brew cask install xquartz
open -a XQuartz
check security - allow connect from network
brew install socat
// login as tao, not root
docker exec -it ubuntu /bin/bash -c 'su - tao && /bin/bash'
vi .bash_profile
// export EDITOR=/usr/bin/vim
// export DISPLAY=192.168.x.x:0  # the host machine's ip
// export LANG=C.UTF-8
exit
docker stop ubuntu
docker start ubuntu
// with xquartz opened, install socat and start it to connect xquartz and docker eontainer
brew install socat
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
```
16. docker exec -it ubuntu /bin/bash -c 'su - tao && /bin/bash'
fcitx-configtool
17. open xquartz, use command + alt + a to show its window
18. **input method list is empty, and fcitx error**
19. sudo apt remove fcitx fcitx-pinyin
20. sudo apt autoremove
21. sudo apt autoclean

由以上测试可以看出，docker ubuntu想要完全替代虚拟机还是不可行的，但我只是想用ubuntu里的
fcitx-vim插件方便在vim中输入中文而已(因为上面记载的mac版fcitx-vim插件有bug)，
然后我发现了下面这个插件: **vimIM**.
```txt
brew install wget
// download the specific version berkeley-db and manual make it accessible to homebrew
sudo su -
wget http://download.oracle.com/berkeley-db/db-6.1.26.tar.gz
tar xvf db-6.1.26.tar.gz
cd db-6.1.26/build_unix
mkdir -p /usr/local/Cellar/berkeley-db/6.1.26
../dist/configure --prefix=/usr/local/Cellar/berkeley-db/6.1.26
make
make install
// ctrl + d exit to normal user
brew link berkeley-db

sudo su -
easy_install pip
YES_I_HAVE_THE_RIGHT_TO_USE_THIS_BERKELEY_DB_VERSION=1 BERKELEYDB_DIR=/usr/local/Cellar/berkeley-db/6.1.26 pip install bsddb3

// ctrl + d exit to normal user
// edit .vimrc and add vimIM plugin to vundle
// but when in insert mode, after ctrl /, vim报错找不到模式，个人感觉是词典的问题。而且
// vimIM不一定有我想要的小鹤双拼输入法。

// 后来github上找到一个基于小鹤双拼的vimIM插件修改版，经测试可以使用，但是它的词库
// 选词太少了，又在网上找到一个小鹤双拼的词库，稍微多一点，但还是容量有限，感觉没有
// 真正的小鹤双拼输入法好用。这时找到emacs编辑器中有个pyim的插件可以完美解决中英文输入的
// 问题，试试吧。
// 具体的emacs实验过程转移到vim tips文章。
```

## 常用命令
docker image ls
docker container ls -a 
// -d daemon  -it iteractive terminal -name containerName -v datasource dir  -p port
docker run -d -it -name -v -p iamgeName

docker logs -f containerName 
docker ps
// check container ip and ports info
docker inspect containerName
docker stop containerName
docker rm containerName
docker rmi imageId


<hr />
<img src="http://wutaotaospace.oss-cn-beijing.aliyuncs.com/image/20200505_1.jpg" class="full-image" />
