#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download
cd ..

echo "Creating haxelib directory and setting up..."
mkdir -p ~/haxelib && haxelib setup ~/haxelib

echo "Checking and installing dependencies..."
echo "This might take a few moments depending on your internet speed."

# 定义通用检测函数
check_and_install() {
  lib_name=$1
  install_command=$2

  if ! haxelib list | grep -q "^$lib_name:"; then
    echo "Installing $lib_name..."
    eval "$install_command"
  else
    echo "$lib_name is already installed, skipping."
  fi
}

# 安装标准库（带版本号）
check_and_install "flixel" "haxelib install flixel 5.6.1"
check_and_install "flixel-addons" "haxelib install flixel-addons 3.2.2"
check_and_install "flixel-tools" "haxelib install flixel-tools 1.5.1"
check_and_install "hscript-iris" "haxelib install hscript-iris 1.1.3"
check_and_install "tjson" "haxelib install tjson 1.4.0"
check_and_install "hxdiscord_rpc" "haxelib install hxdiscord_rpc 1.2.4"
check_and_install "hxvlc" "haxelib install hxvlc 2.0.1 --skip-dependencies"
check_and_install "lime" "haxelib install lime 8.1.2"
check_and_install "openfl" "haxelib install openfl 9.3.3"

# 安装Git仓库库（检测存在性即可）
check_and_install "flxanimate" "haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate 768740a56b26aa0c072720e0d1236b94afe68e3e"
check_and_install "linc_luajit" "haxelib git linc_luajit https://github.com/superpowers04/linc_luajit 1906c4a96f6bb6df66562b3f24c62f4c5bba14a7"
check_and_install "funkin.vis" "haxelib git funkin.vis https://github.com/FunkinCrew/funkVis 22b1ce089dd924f15cdc4632397ef3504d464e90"
check_and_install "grig.audio" "haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git cbf91e2180fd2e374924fe74844086aab7891666"

echo "Dependency check completed!"