## 1 查看全局python信息

### 1.1 查看所有内置模块

```sh
help('modules')
```

```ini
Please wait a moment while I gather a list of all available modules...
BaseHTTPServer      anydbm              inspect             runfiles
Bastion             argparse            interpreterInfo     runpy
CGIHTTPServer       array               io                  sched
Canvas              ast                 itertools           select
ConfigParser        asynchat            json                sets
Cookie              asyncore            keyword             setup_cython
Dialog              atexit              lib                 setuptools
DocXMLRPCServer     audiodev            lib2to3             sgmllib
FileDialog          audioop             linecache           sha
FixTk               base64              locale              shelve
HTMLParser          bdb                 logging             shlex
MimeWriter          binascii            macpath             shutil
Queue               binhex              macurl2path         signal
ScrolledText        bisect              mailbox             site
SimpleDialog        bsddb               mailcap             smtpd
SimpleHTTPServer    bson                markupbase          smtplib
SimpleXMLRPCServer  bz2                 marshal             sndhdr
SocketServer        cPickle             math                socket
StringIO            cProfile            md5                 sqlite3
Tix                 cStringIO           mhlib               sre
Tkconstants         calendar            mimetools           sre_compile
Tkdnd               cgi                 mimetypes           sre_constants
Tkinter             cgitb               mimify              sre_parse
UserDict            chunk               mmap                ssl
UserList            clean_data          modulefinder        stat
UserString          cmath               msilib              statvfs
_LWPCookieJar       cmd                 msvcrt              string
_MozillaCookieJar   code                multifile           stringold
__builtin__         codecs              multiprocessing     stringprep
__future__          codeop              mutex               strop
_abcoll             collections         netrc               struct
_ast                colorsys            new                 subprocess
_bisect             commands            nntplib             sunau
_bsddb              compileall          nt                  sunaudio
_codecs             compiler            ntpath              symbol
_codecs_cn          concurrent          nturl2path          symtable
_codecs_hk          contextlib          numbers             sys
_codecs_iso2022     cookielib           opcode              sysconfig
_codecs_jp          copy                operator            tabnanny
_codecs_kr          copy_reg            optparse            tarfile
_codecs_tw          csv                 os                  telnetlib
_collections        ctypes              os2emxpath          tempfile
_csv                curses              parser              test
_ctypes             datetime            pdb                 textwrap
_ctypes_test        dbhash              pickle              this
_elementtree        decimal             pickletools         thread
_functools          difflib             pip                 threading
_hashlib            dircache            pipes               time
_heapq              dis                 pkg_resources       timeit
_hotshot            distutils           pkgutil             tkColorChooser
_io                 doctest             platform            tkCommonDialog
_json               dumbdbm             plistlib            tkFileDialog
_locale             dummy_thread        popen2              tkFont
_lsprof             dummy_threading     poplib              tkMessageBox
_md5                easy_install        posixfile           tkSimpleDialog
_msi                email               posixpath           toaiff
_multibytecodec     encodings           pprint              token
_multiprocessing    errno               profile             tokenize
_osx_support        exceptions          pstats              trace
_pydev_bundle       filecmp             pty                 traceback
_pydev_comm         fileinput           py_compile          ttk
_pydev_imps         fnmatch             pyclbr              tty
_pydev_runfiles     formatter           pycompletionserver  turtle
_pydevd_bundle      fpformat            pydev_app_engine_debug_startup types
_pydevd_frame_eval  fractions           pydev_console       unicodedata
_pyio               ftplib              pydev_coverage      unittest
_random             functools           pydev_ipython       urllib
_sha                future_builtins     pydev_pysrc         urllib2
_sha256             gc                  pydev_test_pydevd_reload urlparse
_sha512             genericpath         pydev_tests         user
_shaded_ply         getopt              pydev_tests_mainloop uu
_shaded_thriftpy    getpass             pydev_tests_python  uuid
_socket             gettext             pydevconsole        warnings
_sqlite3            glob                pydevd              wave
_sre                gridfs              pydevd_concurrency_analyser weakref
_ssl                gzip                pydevd_file_utils   webbrowser
_strptime           hashlib             pydevd_plugins      wheel
_struct             heapq               pydevd_pycharm      whichdb
_subprocess         hmac                pydevd_tracing      winsound
_symtable           hotshot             pydoc               wsgiref
_testcapi           htmlentitydefs      pydoc_data          xdrlib
_threading_local    htmllib             pyexpat             xml
_tkinter            httplib             pymongo             xmllib
_warnings           idlelib             quopri              xmlrpclib
_weakref            ihooks              random              xxsubtype
_weakrefset         imageop             re                  zipfile
_winreg             imaplib             repr                zipimport
abc                 imghdr              rexec               zlib
activate_this       imp                 rfc822              
aifc                importlib           rlcompleter         
antigravity         imputil             robotparser       
```

### 1.2 查看所有内置函数或类型

```sh
import sys
dir(sys.modules['__builtin__'])
```

```ini
['ArithmeticError', 'AssertionError', 'AttributeError', 'BaseException', 'BufferError', 'BytesWarning', 'DeprecationWarning', 'EOFError', 'Ellipsis', 'EnvironmentError', 'Exception', 'False', 'FloatingPointError', 'FutureWarning', 'GeneratorExit', 'IOError', 'ImportError', 'ImportWarning', 'IndentationError', 'IndexError', 'KeyError', 'KeyboardInterrupt', 'LookupError', 'MemoryError', 'NameError', 'None', 'NotImplemented', 'NotImplementedError', 'OSError', 'OverflowError', 'PendingDeprecationWarning', 'ReferenceError', 'RuntimeError', 'RuntimeWarning', 'StandardError', 'StopIteration', 'SyntaxError', 'SyntaxWarning', 'SystemError', 'SystemExit', 'TabError', 'True', 'TypeError', 'UnboundLocalError', 'UnicodeDecodeError', 'UnicodeEncodeError', 'UnicodeError', 'UnicodeTranslateError', 'UnicodeWarning', 'UserWarning', 'ValueError', 'Warning', 'WindowsError', 'ZeroDivisionError', '_', '__debug__', '__doc__', '__import__', '__name__', '__package__', 'abs', 'all', 'any', 'apply', 'basestring', 'bin', 'bool', 'buffer', 'bytearray', 'bytes', 'callable', 'chr', 'classmethod', 'cmp', 'coerce', 'compile', 'complex', 'copyright', 'credits', 'delattr', 'dict', 'dir', 'divmod', 'enumerate', 'eval', 'execfile', 'exit', 'file', 'filter', 'float', 'format', 'frozenset', 'getattr', 'globals', 'hasattr', 'hash', 'help', 'hex', 'id', 'input', 'int', 'intern', 'isinstance', 'issubclass', 'iter', 'len', 'license', 'list', 'locals', 'long', 'map', 'max', 'memoryview', 'min', 'next', 'object', 'oct', 'open', 'ord', 'pow', 'print', 'property', 'quit', 'range', 'raw_input', 'reduce', 'reload', 'repr', 'reversed', 'round', 'runfile', 'set', 'setattr', 'slice', 'sorted', 'staticmethod', 'str', 'sum', 'super', 'tuple', 'type', 'unichr', 'unicode', 'vars', 'xrange', 'zip']
```



## 2 查看 python 包路径

```sh
import sys
sys.path
```

```ini
['C:\\Program Files\\JetBrains\\PyCharm Community Edition 2020.1.2\\plugins\\python-ce\\helpers\\pydev', 'E:\\workspace\\PyCharm\\cleandata', 'C:\\Program Files\\JetBrains\\PyCharm Community Edition 2020.1.2\\plugins\\python-ce\\helpers\\third_party\\thriftpy', 'C:\\Program Files\\JetBrains\\PyCharm Community Edition 2020.1.2\\plugins\\python-ce\\helpers\\pydev', 'C:\\WINDOWS\\SYSTEM32\\python27.zip', 'E:\\workspace\\PyCharm\\cleandata\\venv\\DLLs', 'E:\\workspace\\PyCharm\\cleandata\\venv\\lib', 'E:\\workspace\\PyCharm\\cleandata\\venv\\lib\\plat-win', 'E:\\workspace\\PyCharm\\cleandata\\venv\\lib\\lib-tk', 'E:\\workspace\\PyCharm\\cleandata\\venv\\Scripts', 'C:\\Python27\\Lib', 'C:\\Python27\\DLLs', 'C:\\Python27\\Lib\\lib-tk', 'E:\\workspace\\PyCharm\\cleandata\\venv', 'E:\\workspace\\PyCharm\\cleandata\\venv\\lib\\site-packages', 'E:\\workspace\\PyCharm\\cleandata', 'E:/workspace/PyCharm/cleandata']
```

## 3 help 使用

当对 python 的整体模块，整体的内置函数，数据类型等有一个了解后，可以使用 help 查看更进一步的详细信息。

### 3.1 查看具体模块

> 查看模块要加上单引号，help('函数名称')

```sh
help('sys')
```

### 3.2 查看函数

1. 查看内置函数，直接写函数名：help(函数名)

```sh
help(vars)
help(abs)
```

2. 查看模块下的函数：help(模块名.函数名)

   > **NOTE**:不要带上括号

```sh
help(sys.path)
```





