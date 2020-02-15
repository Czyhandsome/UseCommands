## 有用命令

### - 查看CLOSE_WAIT线程数量

LINUX:

```bash
# 查看数量
sudo netstat -anp|grep CLOSE_WAIT|wc -l

# 查看具体信息
sudo netstat -anp|grep CLOSE_WAIT
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

