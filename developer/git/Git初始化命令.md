 Command line instructions
Git global setup
```
git config --global user.name "chengkaixiong"
git config --global user.email "chengkaixiong@thinktrader.net"
```

Create a new repository
```
git clone http://172.21.12.13:8090/chengkaixiong/monitorhub.git
cd monitorhub
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
```

Existing folder
```
cd existing_folder
git init
git remote add origin http://172.21.12.13:8090/chengkaixiong/monitorhub.git
git add .
git commit -m "Initial commit"
git push -u origin master
```

Existing Git repository
```
cd existing_repo
git remote add origin http://172.21.12.13:8090/chengkaixiong/monitorhub.git
git push -u origin --all
git push -u origin --tags
```
