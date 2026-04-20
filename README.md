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
これは`class Setting`の内部構造にアクセスするための`getCSetting()`というメンバ関数を追加するものである．この関数は`libbarrett`から頻繁に呼ばれる．

さらに，本パッケージをダウンロードしてビルド用のディレクトリを作り，そこでビルドしてインストールする．
```
git clone https://github.com/Task-Intelligent-Robotics-Research-Grp/libbarrett
mkdir libbarrett/build
cd libbarrett/build
cmake ..
make
sudo make install
```

### 参考リンク
- [libbarrett documentation](https://web.barrett.com/libbarrett/index.html)
- [Barrett Technology社リポジトリ](https://git.barrett.com/software)
- [Barrett Hand製品情報](https://barrett.com/barretthand)
- [Barrett Hand関連情報](https://longsengao.com/blog/BarrettHand-BH8-282-Manual/)

また，[本パッケージのオリジナルのREADME](./README-org.md)も残してある．