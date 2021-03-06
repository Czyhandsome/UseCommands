## 有用命令

### - 查看CLOSE_WAIT线程数量

LINUX:

```bash
# 查看数量
sudo netstat -anp|grep CLOSE_WAIT|wc -l

# 查看具体信息
sudo netstat -anp|grep CLOSE_WAIT

# 查看每个进程有多少个CLOSE_WAIT
netstat -antp|grep CLOSE_WAIT | perl -lane 'print $1 if (@F[6] =~ /(\d+)(\/java)/)' | awk '{a[$1]++} END {for (i in a) { printf("%s %d\n", i, a[i]) } }' | sort -rnk2
```

Windows:

```bash
netstat -ano | findstr CLOSE_WAIT
```

### - 安装windows linux subsystem

```bash
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Add-AppxPackage .\app_name.appx
```

### - 查看文件系统中最大的20个文件

- `du -a [dir] | sort -n -r | head -n 20` 查看文件大小

  ```bash
  # 当前目录下
  du -a . | sort -n -r | head -n 20
  ```


  或者

  ```bash
find /usr/server -xdev -type f -size +100M -exec ls -la {} \; | sort -rnk 5

### 过滤.log文件
find /usr/server -xdev -type f -name "*.log" -exec ls -la {} \; | sort -rnk 5 | head -n 20
  ```

- 设置go get的https代理：

```bash
#!/bin/bash
export http_proxy=socks5://127.0.0.1:7891 # 代理地址
export https_proxy=$http_proxy
export | grep http
```

- 在windows上设置：

```powershell
# 启用 Go Modules 功能
$env:GO111MODULE="on"
# 配置 GOPROXY 环境变量
$env:GOPROXY="https://goproxy.io"
```

可使用`go get`下载包。

或者使用：

goproxy.cn,direct

### - 跳转到当前脚本所在目录

```zsh
# 进入目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}" || exit;
```

### - 查看文件是否存在

```zsh
if [ ! -f /tmp/foo.txt ]; then
    echo "File not found!"
fi
```

### - 将文件内容直接置入剪贴板中 

```bash
clip < file-to-import.txt
```

### - 截取文件X字节后的文件

```bash
# 去掉lsm.lyb的前4个字节，然后写到lsm-noheader.lyb中
tail -c+5 lsm.lyb > lsm-noheader.lyb
```

### - 通过curl查看网站访问耗时时间

- 创建curl格式文件`curl-format.txt`，可以定义curl命令打印输出格式：

```txt
    time_namelookup:  %{time_namelookup}s\n
       time_connect:  %{time_connect}s\n
    time_appconnect:  %{time_appconnect}s\n
   time_pretransfer:  %{time_pretransfer}s\n
      time_redirect:  %{time_redirect}s\n
 time_starttransfer:  %{time_starttransfer}s\n
                    ----------\n
         time_total:  %{time_total}s\n
```

- 使用`curl -w "@<format文件名>"`访问网站，获取信息：

```bash
curl -w "@curl-format.txt" -o /dev/null -s "https://www.baidu.com"
```

### - 查看apt仓库列表

```bash
grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/*
```



## Golang

### - 交叉编译go

```bash
GOOS=linux GOARCH=amd64 go build hello.go
```

### - fmt.Printf对齐

- 使用`%10s`进行**右对齐**！

```go
fmt.Printf("%10s", "Hello")
```

- 使用`%-10s`进行**左对齐**！

```go
fmt.Printf("%-10s", "Hello")
```



## CMake

### - 添加库

```cmake
cmake_minimum_required(VERSION 3.10)
project(yaml_usage)

set(CMAKE_CXX_STANDARD 14)

# 设置库的路径
#INCLUDE_DIRECTORIES(/usr/local/include)
#LINK_DIRECTORIES(/usr/local/lib)

# 链接到库
add_executable(yaml_usage main.cpp)
TARGET_LINK_LIBRARIES(yaml_usage OFF.a)
```

## Bash

### - 进入当前目录

```bash
# Go to current dir
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "${DIR}" || exit
```

### - for循环字面变量
```bash
for plugin in "autosuggestions" "syntax-highlighting" "docker"
do
    git clone https://github.com/zsh-users/zsh-${plugin}.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-${plugin}
done
```

### - 遍历所有参数

```bash
function showParams() {
    for param in "$@"; do
      echo “$param";
    done;
}
```

### - 使用`xargs`执行命令，杀灭指定名称java进程

```bash
# 消灭Zuul为名称的Java进程
jps -l | grep Zuul | cut -d ' ' -f 1 | xargs -I {} kill -15 {}
```

### - 将`stdout`或`stderr`赋值给某个变量

```bash
# 将stderr给err
err=$(curl -m 5 "http://localhost:9089/DemoServiceA/v1/instances" 2>&1)

# 将stdout给result
result=$(curl -m 5 "http://localhost:9089/DemoServiceA/v1/instances")
```

### - 遍历所有目录

```bash
for dir in */; do
  echo "$dir";
done;
```

- 例子：更新当前目录下所有的Git或Svn:

```bash
#!/usr/bin/env bash

# Go to self
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "${DIR}" || exit

for dir in */; do
  cd "$dir" || exit
  if [[ -d .git ]]; then
    echo "Find git! Updating..."
    git pull
  elif [[ -d .svn ]]; then
    echo "Find svn! Updating..."
    svn update
  else
    echo "Not git or svn! Ignoring..."
  fi
  cd ..
done
```



### - 使用`getopts`读取flag参数

```bash
#!/bin/bash

verbose=false

function usage () {
    cat <<EOUSAGE
$(basename $0) hvr:e:
    show usage
EOUSAGE
}

while getopts :hvr:e: opt
do
    case $opt in
        v)
            verbose=true
            ;;
        e)
            option_e="$OPTARG"
            ;;
        r)
            option_r="$option_r $OPTARG"
            ;;
        h)
            usage
            exit 1
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 2
            ;;
    esac
done


echo "Verbose is $verbose"
echo "option_e is \"$option_e\""
echo "option_r is \"$option_r\""
echo "\$@ pre shift is \"$@\""
shift $((OPTIND - 1))
echo "\$@ post shift is \"$@\""
```

结果是：

```terminal
$ ./test-getopts.sh -r foo1 -v -e bla -r foo2 remain1 remain2
Verbose is true
option_e is "bla"
option_r is " foo1 foo2"
$@ pre shift is "-r foo1 -v -e bla -r foo2 remain1 remain2"
$@ post shift is "remain1 remain2"
```



### - 条件判断

```txt
-a file
True if file exists.

-b file
True if file exists and is a block special file.

-c file
True if file exists and is a character special file.

-d file
True if file exists and is a directory.

-e file
True if file exists.

-f file
True if file exists and is a regular file.

-g file
True if file exists and its set-group-id bit is set.

-h file
True if file exists and is a symbolic link.

-k file
True if file exists and its "sticky" bit is set.

-p file
True if file exists and is a named pipe (FIFO).

-r file
True if file exists and is readable.

-s file
True if file exists and has a size greater than zero.

-t fd
True if file descriptor fd is open and refers to a terminal.

-u file
True if file exists and its set-user-id bit is set.

-w file
True if file exists and is writable.

-x file
True if file exists and is executable.

-G file
True if file exists and is owned by the effective group id.

-L file
True if file exists and is a symbolic link.

-N file
True if file exists and has been modified since it was last read.

-O file
True if file exists and is owned by the effective user id.

-S file
True if file exists and is a socket.

file1 -ef file2
True if file1 and file2 refer to the same device and inode numbers.

file1 -nt file2
True if file1 is newer (according to modification date) than file2, or if file1 exists and file2 does not.

file1 -ot file2
True if file1 is older than file2, or if file2 exists and file1 does not.

-o optname
True if the shell option optname is enabled. The list of options appears in the description of the -o option to the set builtin (see The Set Builtin).

-v varname
True if the shell variable varname is set (has been assigned a value).

-R varname
True if the shell variable varname is set and is a name reference.

-z string
True if the length of string is zero.

-n string
string
True if the length of string is non-zero.

string1 == string2
string1 = string2
True if the strings are equal. When used with the [[ command, this performs pattern matching as described above (see Conditional Constructs).

‘=’ should be used with the test command for POSIX conformance.

string1 != string2
True if the strings are not equal.

string1 < string2
True if string1 sorts before string2 lexicographically.

string1 > string2
True if string1 sorts after string2 lexicographically.

arg1 OP arg2
OP is one of ‘-eq’, ‘-ne’, ‘-lt’, ‘-le’, ‘-gt’, or ‘-ge’. These arithmetic binary operators return true if arg1 is equal to, not equal to, less than, less than or equal to, greater than, or greater than or equal to arg2, respectively. Arg1 and arg2 may be positive or negative integers. When used with the [[ command, Arg1 and Arg2 are evaluated as arithmetic expressions (see Shell Arithmetic).
```

### - 设置LC_LOCALE

在`~/.bashrc`中增加如下语句：

```bash
export LC_ALL="en_US.UTF-8"
```

### - 将所有参数传递给bash

- 使用`$@`可以将所有参数（除了**$0**，它代表这个bash脚本的名称）通过空格连接起来。

```bash
# 打印所有参数
function printArgs() {
    echo "$@"
}

# $ printArgs 1 2 3.txt
# 结果：1 2 3.txt

# 执行redis-cli
redis-cli -h 172.31.203.8 -p 6391 -a 'UIX*$MD78p' "$@"
```

### - 将字符串转为小写

```bash
serviceName=$(echo "$2" | awk 'print tolower{$0}')
```

### - 提取文件名、文件名无后缀与文件后缀名

```bash
filename=$(basename -- "$1")
extension="${filename##*.}"
filename="${filename%.*}"
```



## SED

### - 字符串替换

```bash
# 将172.31.63.26替换为172.31.236.3
sed -i 's/172\.31\.63\.26/172\.31\.236\.3/' conf/nginx.conf

# 将devrec.xxx.com改为devrec2.xxx.com
sed -i 's/devrec\.xxx\.com/devrec2\.xxx\.com/' conf/nginx.conf
```



## AWK

### - 内置变量

https://www.tutorialspoint.com/awk/awk_built_in_variables.htm

| 名称     | 作用             | 示例            |
| -------- | ---------------- | --------------- |
| ARGC     | 变量数量         |                 |
| ARGV     | 变量列表         | ARGV[0]         |
| ENVIRON  | 环境变量Map      | ENVIRON["USER"] |
| FILENAME | 文件名称         |                 |
| NF       | Number of fields |                 |
| NR       | 当前行数         |                 |
| $0       | 当前记录         |                 |
| $1       | 第一个field      |                 |

### - 查看每分钟有多少个请求

```bash
# 将request log过滤出来
cat yyzx_managementwebv2.log | grep "request log:" > "request_log.log";

# 直接在原始request_log文件上记录每分钟访问的次数
cat request_log.log | awk '
{
	txt=sprintf("%s %s", $1, substr($2, 0, 5))
    a[txt]++
}

END {
    for (i in a) {
	    printf("%s %d\n", i, a[i])
	}
}
' | sort > "counting.log";
```

### 将多行文件转化为括号逗号分隔

```bash
awk -vORS=, 'BEGIN{ print "(" }{ print $0 } END { print ")" }' file-name | sed 's/,$/\n/' | sed 's/,)/)/'
```


## SORT

### - 根据第3列排序

```bash
sort -nrk 3 FILE.txt
```

- `-n`：第几列，这里为3
- `-r`

## Git

### - 给TortoiseGit设置ssh-key并上传至github上

[给TortoiseGit设置ssh-key并上传至github上](https://blog.csdn.net/gnail_oug/article/details/78794339)

使用软件：

- PuTTY GEN

- Pageant



### - Git回退某个版本

```bash
# 必须在工作空间干净时运行
git revert <commit-id>
```



##  Node/Npm

### - 设置淘宝镜像

```bash
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

## MySQL

### - 查看字符集

```mysql
# 查看表字符集
SHOW TABLE STATUS WHERE name = 'TABLE_NAME';

# 查看数据库默认字符集
SELECT * FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = 'DATABASE_NAME';
```

### - 查看数据库表的数量

```mysql
SELECT COUNT(*) AS TOTAL_NUMBER_OF_TABLES
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = '{{DATA_BASE_NAME}}';
```

### - 查看MySQL事务/锁/进程信息

```mysql
# 查看innoDB引擎状态
SHOW ENGINE INNODB STATUS;
```

查看以后，大概的信息如下：

```txt

=====================================
2020-02-16 09:32:58 0x7fd2cae39700 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 7 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 2976499 srv_active, 0 srv_shutdown, 235722 srv_idle
srv_master_thread log flush and writes: 3212217
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 6112541
OS WAIT ARRAY INFO: signal count 12743155
Mutex spin waits 0, rounds 0, OS waits 0
RW-shared spins 5267065, rounds 7094023, OS waits 1827960
RW-excl spins 208566, rounds 7428472968, OS waits 131730
RW-sx spins 3302099, rounds 8099724, OS waits 10669
Spin rounds per wait: 0.00 mutex, 1.35 RW-shared, 35616.89 RW-excl, 2.45 RW-sx
------------------------
LATEST FOREIGN KEY ERROR
------------------------
2020-02-09 16:04:28 0x7fd2b85de700  Cannot drop table `YYZX_DevManagementWeb_Quartz`.`QRTZ_JOB_DETAILS`
because it is referenced by `YYZX_DevManagementWeb_Quartz`.`QRTZ_TRIGGERS`
------------------------
LATEST DETECTED DEADLOCK
------------------------
2020-01-16 09:08:52 0x7fd3b8d75700
*** (1) TRANSACTION:
TRANSACTION 618064503, ACTIVE 4 sec inserting
mysql tables in use 1, locked 1
LOCK WAIT 3 lock struct(s), heap size 1136, 2 row lock(s)
MySQL thread id 199935, OS thread handle 140543295018752, query id 113385371 172.31.6.48 tjkjmt update
INSERT INTO T_JK_PC_QRTZ_SCHEDULER_STATE (SCHED_NAME, INSTANCE_NAME, LAST_CHECKIN_TIME, CHECKIN_INTERVAL) VALUES('hiseeJK_pc_2.4.1', 'ubuntu1579095769375', 1579136919676, 20000)
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 15863 page no 3 n bits 96 index PRIMARY of table `MTYW_hiseeJK_pc_2.4.1`.`T_JK_PC_QRTZ_SCHEDULER_STATE` trx id 618064503 lock_mode X insert intention waiting
Record lock, heap no 1 PHYSICAL RECORD: n_fields 1; compact format; info bits 0
 0: len 8; hex 73757072656d756d; asc supremum;;

*** (2) TRANSACTION:
TRANSACTION 618064470, ACTIVE 8 sec inserting
mysql tables in use 1, locked 1
3 lock struct(s), heap size 1136, 2 row lock(s)
MySQL thread id 199978, OS thread handle 140547315947264, query id 113385867 10.6.50.73 tjkjmt update
INSERT INTO T_JK_PC_QRTZ_SCHEDULER_STATE (SCHED_NAME, INSTANCE_NAME, LAST_CHECKIN_TIME, CHECKIN_INTERVAL) VALUES('hiseeJK_pc_2.4.1', 'XQLI71579136686123', 1579136949143, 20000)
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 15863 page no 3 n bits 96 index PRIMARY of table `MTYW_hiseeJK_pc_2.4.1`.`T_JK_PC_QRTZ_SCHEDULER_STATE` trx id 618064470 lock_mode X
Record lock, heap no 1 PHYSICAL RECORD: n_fields 1; compact format; info bits 0
 0: len 8; hex 73757072656d756d; asc supremum;;

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 15863 page no 3 n bits 96 index PRIMARY of table `MTYW_hiseeJK_pc_2.4.1`.`T_JK_PC_QRTZ_SCHEDULER_STATE` trx id 618064470 lock_mode X insert intention waiting
Record lock, heap no 1 PHYSICAL RECORD: n_fields 1; compact format; info bits 0
 0: len 8; hex 73757072656d756d; asc supremum;;

*** WE ROLL BACK TRANSACTION (2)
------------
TRANSACTIONS
------------
Trx id counter 654696236
Purge done for trx's n:o < 654696236 undo n:o < 0 state: running but idle
History list length 852
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 422026684725112, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
*** 其他信息……
--------
FILE I/O
--------
I/O thread 0 state: waiting for completed aio requests (insert buffer thread)
I/O thread 1 state: waiting for completed aio requests (log thread)
*** 其他信息……
Pending normal aio reads: 0 [0, 0, 0, 0] , aio writes: 0 [0, 0, 0, 0] ,
 ibuf aio reads: 0, log i/o's: 0, sync i/o's: 0
Pending flushes (fsync) log: 0; buffer pool: 0
1746551 OS file reads, 80241065 OS file writes, 12569889 OS fsyncs
0.00 reads/s, 0 avg bytes/read, 10.57 writes/s, 1.29 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 29070, seg size 29072, 260875 merges
merged operations:
 insert 5245378, delete mark 88844928, delete 2917
discarded operations:
 insert 0, delete mark 0, delete 0
Hash table size 4730347, node heap has 374 buffer(s)
58.56 hash searches/s, 512.64 non-hash searches/s
---
LOG
---
Log sequence number 771416362064
Log flushed up to   771416362064
Pages flushed up to 771264454377
Last checkpoint at  771264454377
0 pending log flushes, 0 pending chkp writes
46909178 log i/o's done, 10.57 log i/o's/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total large memory allocated 2198863872
Dictionary memory allocated 55996818
Buffer pool size   131056
Free buffers       8194
Database pages     122488
Old database pages 45050
Modified db pages  1579
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 1393651, not young 528414992
0.00 youngs/s, 0.00 non-youngs/s
Pages read 1741035, created 3325533, written 30965343
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
Buffer pool hit rate 1000 / 1000, young-making rate 0 / 1000 not 0 / 1000
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 122488, unzip_LRU len: 0
I/O sum[0]:cur[0], unzip sum[0]:cur[0]
----------------------
INDIVIDUAL BUFFER POOL INFO
----------------------
---BUFFER POOL 0
Buffer pool size   16382
Free buffers       1024
Database pages     15311
Old database pages 5631
Modified db pages  459
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 180753, not young 64859879
0.00 youngs/s, 0.00 non-youngs/s
Pages read 216007, created 417941, written 6278573
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
Buffer pool hit rate 1000 / 1000, young-making rate 0 / 1000 not 0 / 1000
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 15311, unzip_LRU len: 0
I/O sum[0]:cur[0], unzip sum[0]:cur[0]
---BUFFER POOL 1
Buffer pool size   16382
Free buffers       1025
Database pages     15311
Old database pages 5631
Modified db pages  40
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 156931, not young 64965452
0.00 youngs/s, 0.00 non-youngs/s
Pages read 217546, created 412566, written 2663241
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
Buffer pool hit rate 1000 / 1000, young-making rate 0 / 1000 not 0 / 1000
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 15311, unzip_LRU len: 0
I/O sum[0]:cur[0], unzip sum[0]:cur[0]
*** 其他信息……
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
0 read views open inside InnoDB
Process ID=4438, Main thread ID=140547753764608, state: sleeping
Number of rows inserted 176058587, updated 32391746, deleted 42864076, read 15806076259
2.43 inserts/s, 13.43 updates/s, 2.57 deletes/s, 466.65 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================

```

可以通过查看**Thread**、**Transaction**等查看当前事务回滚、死锁等情况。

### - 常用`INFORMATION_SCHEMA`查询命令

- 查看当前事务等待的锁：

```mysql
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS;
```

- 查看当前被锁住的事务：

```mysql
SELECT * 
FROM INNODB_LOCKS 
WHERE LOCK_TRX_ID IN (SELECT BLOCKING_TRX_ID FROM INNODB_LOCK_WAITS);
```

或者

```mysql
SELECT INNODB_LOCKS.* 
FROM INNODB_LOCKS
JOIN INNODB_LOCK_WAITS
  ON (INNODB_LOCKS.LOCK_TRX_ID = INNODB_LOCK_WAITS.BLOCKING_TRX_ID);
```

某具体表的锁：

```mysql
SELECT * FROM INNODB_LOCKS 
WHERE LOCK_TABLE = <db_name>.<table_name>;
```

当前等待锁的事务：

```mysql
SELECT TRX_ID, TRX_REQUESTED_LOCK_ID, TRX_MYSQL_THREAD_ID, TRX_QUERY
FROM INNODB_TRX
WHERE TRX_STATE = 'LOCK WAIT';
```

**Reference** - [MySQL Troubleshooting: What To Do When Queries Don't Work](https://rads.stackoverflow.com/amzn/click/com/1449312004), Chapter 6 - Page 96.



### - 截取字符串

```mysql
SELECT SUBSTR('Hello My Dear friend!', 2, 6)
# 结果：'ello M'
```

### - 分组查询，合并行

```mysql
SELECT p.Id
       GROUP_CONCAT(b.BizId SEPARATOR ', ') AS `Data`
FROM FatherData p
         JOIN ChildData b ON p.Id = b.DataId AND b.DataType = 4
GROUP BY p.Id;
```

### 删除表中重复字段

```mysql
CREATE TEMPORARY TABLE tmpTable
(
    id INT
);

INSERT INTO tmpTable
    (id)
SELECT id
FROM YourTable yt
WHERE EXISTS
          (
              SELECT *
              FROM YourTabe yt2
              WHERE yt2.title = yt.title
                AND yt2.company = yt.company
                AND yt2.site_id = yt.site_id
                AND yt2.id > yt.id
          );

DELETE
FROM YourTable
WHERE ID IN (SELECT id FROM tmpTable);
```


## Redis

### - 查看sentinel与master的信息

```bash
# 查看sentinel节点对应的master信息
redis-cli -h <ip> -p <port> info|grep status
```



### - 根据pattern删除keys

```bash
redis-cli --scan --pattern "*Slicing*" | xargs redis-cli del
```





## Groovy

### - 运行groovy程序

```groovy
task runScript(dependsOn: 'classes', type: JavaExec) {
    def key = "Main"
    # 设置main
    if (project.hasProperty(key)) {
        main = project.getProperties().get(key)
    } else {
        main = "Usage"
    }
    # 设置classpath
    classpath = sourceSets.main.runtimeClasspath
}
```

## Java

### - 运行jmx

```bash
java \
-Dcom.sun.management.jmxremote.port=1099 \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
-Djava.rmi.server.hostname=localhost \
-jar <JAR_NAME>
```



注：

1. -Dcom.sun.management.jmxremote.port ：这个是配置远程 connection 的端口号的，要确定这个端口没有被占用

2. -Dcom.sun.management.jmxremote.ssl=false 指定了 JMX 是否启用 ssl

3. -Dcom.sun.management.jmxremote.authenticate=false  指定了JMX 是否启用鉴权（需要用户名，密码鉴权）

4. -Djava.rmi.server.hostname ：这个是配置 server 的 IP 的

## Zsh

### - Oh My Zsh
[https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/](https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/)


## pandoc

### - pdf to html

```
pandoc MANUAL.txt --pdf-engine=xelatex -o example13.pdf
```

## 加密（openssl）
```
openssl enc -salt -aes256 -pbkdf2 -iter 100000 -a -in 这是我的书.md -out 这是我的书.md.enc
openssl enc -salt -aes256 -pbkdf2 -iter 100000 -d -a -in 这是我的书.md.enc -out 这是我的书.md
```

## Mac

### 修复USB连接iPhone后频繁闪烁的问题

```bash
sudo killall -STOP -c usbd
```
