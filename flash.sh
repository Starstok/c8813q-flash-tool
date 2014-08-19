#!/system/bin/sh
bb=busybox
$bb clear
#
if [ -f /sdcard/flash.zip ] ;then
echo "检测到已经过下载flash.zip。"
$bb sleep 1s
$bb clear
if [ -f /sdcard/flash/read.txt ] ;then
echo
else
echo "检测到已经下载flash.zip,但并没有安装，现在开始安装！"
$bb sleep 1s
$bb clear
cd /sdcard
$bb unzip flash.zip
$bb sleep 1s
$bb clear
fi
fi
if [ -f /sdcard/flash/read.txt ] ;then
echo "检测到已经安装flash"
$bb sleep 2s
else

echo "检测到没有安装flash"
echo "没有安装flash,工具无法工作"
echo "是否安装？"
echo "y/YES or n/NO"
read down
if [ "$down" = "y" ] ;then
echo "开始下载请稍等！请注意连接互联网"
cd /sdcard
$bb wget -c http://fust.wodemo.com/down/20140709/295746/flash.zip

echo "现在完成开始解压，稍等"
$bb sleep 1s
cd /sdcard
echo "正在进入SD卡"
$bb sleep 1s
$bb unzip flash.zip
echo "OK"
$bb sleep 2s
else
exit
fi
fi
#
$bb clear
echo "正在进入系统，请稍等"
echo "..."
$bb sleep 1s
$bb clear
echo "正在进入系统，请稍等"
echo "......"
$bb sleep 1s
$bb clear
echo "正在进入系统，请稍等"
echo "........."
$bb sleep 1s
$bb clear
echo "正在进入系统，请稍等"
echo "............"
$bb sleep 1s
$bb clear
echo "正在进入系统，请稍等"
echo "..............."
$bb sleep 1s
$bb clear
echo "正在进入系统，请稍等"
echo ".................."
$bb clear
#
CopyFiles() {
mount -o remount,rw rootfs /system
echo
echo
echo
echo "复制下文件到/system/xbin/"
busybox cp /sdcard/flash/bin/* /system/xbin/
for i in `ls /sdcard/flash/bin/*`
do
echo /system/xbin/${i##*/}
chmod 755 /system/xbin/${i##*/}
done
echo "OK"
$bb sleep 1s
echo
echo
echo
main
}
Lock() {
$bb clear
echo
echo
echo
echo "解锁工具"
echo
echo "1)备份oem.img"
echo "2)还原oem.img"
echo "3)解锁oem.img"
echo
echo "x)返回上级菜单"
echo
echo "请选择:"
read Lock
case $Lock in
	1*) dd if=/dev/block/mmcblk0p5 of=/sdcard/flash/dd/oem/oem.img;;
	2*) dd if=/sdcard/flash/dd/oem/oem.img of=/dev/block/mmcblk0p5;;
   3*) dd if=/sdcard/flash/unlock/oem.img of=/dev/block/mmcblk0p5;;
   x*) main;;
*) Lock;;
esac
echo "OK"
echo
echo
echo
main
}
FlashRec() {
$bb clear
echo
echo
echo
echo "刷写recovery"
echo
echo "1)刷写recovery"
echo
echo "x)返回上级菜单"
echo
echo "请选择"
read Rec
case $Rec in
	1*) flash_image /dev/block/mmcblk0p13 /sdcard/flash/rec/recovery.img;;
x*) main;;
*) FlashRec;;
esac
echo "OK"
echo
echo
echo
main
}
Ddif() {
$bb clear
echo
echo
echo
echo "备份recovery"
echo
echo "1)备份rec"
echo "2)还原rec"
echo
echo "x)返回上级菜单"
echo
echo "请选择:"
read Dd
case $Dd in
	1*) dd if=/dev/block/mmcblk0p13 of=/sdcard/flash/dd/recovery/recovery.img;;
	2*) dd if=/sdcard/flash/dd/recovery/recovery.img of=/dev/block/mmcblk0p13;;
   x*) main;;
*) Ddif;;
esac
echo "OK"
echo
echo
echo
main
}
Reboot() {
$bb clear
echo
echo
echo
echo "高级重启菜单"
echo
echo "1)重启"
echo "2)重启到recovery"
echo
echo "x)返回上级菜单"
echo
echo "请选择:"
read Reboot
case $Reboot in
	1*) reboot;;
	2*) reboot recovery;;
   x*) main;;
*) Reboot;;
esac
echo "OK"
echo
echo
echo
main
}
main() {
$bb clear
echo "本脚本由包子KK开发，禁止任何人用于任何商业用途，转载请注明出处
QQ:35354790
e-mail:35354790@qq.com"
echo
echo "使用本工具必须安装busybox,机器root"
echo "菜单:"
echo
echo "1) 复制文件"
echo "2) 解锁工具"
echo "3) 刷写Recovery"
echo "4) 备份recovery"
echo "5) 高级电源菜单"
echo "6) 帮助"
echo "x) 退出"
echo "请选择: "
read type
case $type in
1*) CopyFiles;;
2*) Lock;;
3*) FlashRec;;
4*) Ddif;;
5*) Reboot;;
6*) $bb clear;echo "`cat /sdcard/flash/read.txt`";$bb sleep 5s;main;;
su*) su;;
x*) exit;;
*) main;;
esac
}
#
if [ -d /system/etc/cmd ] ;then
main
else
ABC() {
$bb clear
echo "请输入密码:"
echo "退出请输入"exit""
read abc
case $abc in
19981113) mkdir /system/etc/cmd;main;;
exit) exit;;
*) $bb clear;
echo "密码输入错误!";
$bb sleep 1s;
$bb clear;
ABC;;
esac
}
ABC
fi

