# dot_app

用来遍历查询 .app 域名是否被注册。

使用方法

```
require './dot_app'

# 单拼&双单拼
DotApp.danpin

# 中文词汇
DotApp.webdict
```

除了运行时会直接打印出来外，还会定时（每100个未注册域名）保存到 store_danpin.txt 或者 store_webdict.txt 文件中。Command+C可停止执行，仍可保存当前查询结果。