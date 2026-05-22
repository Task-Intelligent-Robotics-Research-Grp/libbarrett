![GitHub release (latest by date)](https://img.shields.io/github/v/release/Task-Intellignet-Robotics-Research-Grp/libbarrett)
![GitHub](https://img.shields.io/github/license/Task-Intellignet-Robotics-Research-Grp/libbarrett)

| ROS 2 Distribution | Jazzy                                                                                                                                                                    |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Build Status       | [![jazzy-build](https://github.com/Task-Intelligent-Robotics-Research-Grp/libbarrett/actions/workflows/noble-build.yaml/badge.svg)](https://github.com/Task-Intelligent-Robotics-Research-Grp/libbarrett/actions/workflows/noble-build.yaml) |

# libbarrett
本パッケージは [Barrett Technology](https://barrett.com/)社の製品を制御するために同社が提供しているライブラリ[libbarrett](https://git.barrett.com/software/libbarrett)に対して．`Ubuntu 24.04`等の最近のLinuxでビルドできるように僅かな修正を加えたものである．新たなブランチ`devel-aist`を切り，そこで修正を行っている．

### インストール方法
まず，次の依存パッケージをインストールする．
```
sudo apt install libgsl-dev libconfig++-dev
```
そして，（ライブラリAPIのカプセル化を破るので本来好ましくないが）`libconfig++`のヘッダファイル`/usr/include/libconfig.h++`を以下のように修正する．
```
*** libconfig.h++.ORG0	2026-04-20 08:41:31.962424633 +0900
--- libconfig.h++	2026-04-20 10:08:25.503322203 +090
***************
*** 319,324 ****
--- 319,326 ----
    const_iterator begin() const;
    const_iterator end() const;
  
+   config_setting_t* getCSetting() const { return _setting; }	// Added by T.Ueshiba
+  
    private:
  
    config_setting_t *_setting;
```
これは`class Setting`にその内部構造にアクセスするための`getCSetting()`というメンバ関数を追加するものである．この関数は`libbarrett`から頻繁に呼ばれる．

最後に，本パッケージをダウンロードしてビルド用のディレクトリを作り，そこでビルドしてインストールする．
```
git clone https://github.com/Task-Intelligent-Robotics-Research-Grp/libbarrett
mkdir libbarrett/build
cd libbarrett/build
cmake ..
make
sudo make install
```

### CAN(Controller Area Network)の有効化
`Barrett`社のデバイスはフィールドバスの標準的なシリアル通信プロトコルである`CAN(Controller Area Networks)`を基盤としており，`libbarrett`は`CAN`を介してデバイスを制御する．`Linux`には`CAN`のカーネルモジュールが含まれているので，初期設定スクリプト[reset_can.sh](./scripts/reset_can.sh)とホスト起動時にそれを呼び出す[60-can.rules](./scripts/60-can.rules)をインストールして`CAN`を使えるようにする．
```
cd libbarrett/scripts
sudo cp reset_can.sh /usr/local/bin
sudo cp 60-can.rules /etc/udev/rules.d
sudo udevadm control --reload
sudo udevadm trigger
```
ここで，USB-CANコンバータ等を介してPCに`CAN`デバイスを接続し，`ip a`コマンドを実行して
```
% ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000

   ...

7: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UP group default qlen 10
    link/can 
```
のように`can0`のエントリが表示されれば，`CAN`が有効化されている．

なお，複数のコンバータを接続している場合は，`can0`, `can1`, ...のように複数のエントリが表示されるべきである．`can1`以降も有効化するには，上記[reset_can.sh](./scripts/reset_can.sh)に`sudo ip link set...`を追加する必要がある．


### 参考リンク
- [libbarrett documentation](https://web.barrett.com/libbarrett/index.html)
- [Barrett Technology社リポジトリ](https://git.barrett.com/software)
- [Barrett Hand製品情報](https://barrett.com/barretthand)
- [Barrett Hand関連情報](https://longsengao.com/blog/BarrettHand-BH8-282-Manual/)

また，[本パッケージのオリジナルのREADME](./README-org.md)も残してある．