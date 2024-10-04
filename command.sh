#!/bin/bash

show_menu() {
    echo "Pilih flavor yang ingin di-run/build:"
    echo "1) redCamera"
    echo "2) redGallery"
    echo "3) greenFile"
    echo "4) greenGallery"
    echo "5) Keluar"
}

handle_choice() {
    case $1 in
        1)
            FLAVOR="redCamera"
            ;;
        2)
            FLAVOR="redGallery"
            ;;
        3)
            FLAVOR="greenFile"
            ;;
        4)
            FLAVOR="greenGallery"
            ;;
        5)
            echo "Keluar."
            exit 0
            ;;
        *)
            echo "Pilihan tidak valid!"
            exit 1
            ;;
    esac
}

run_or_build() {
    echo "Pilih aksi:"
    echo "1) Run aplikasi"
    echo "2) Build APK debug"
    read -p "Masukkan pilihan (1/2): " ACTION

    if [ "$ACTION" == "1" ]; then
        flutter run -t lib/main.dart --dart-define=flavor=$FLAVOR --flavor $FLAVOR
    elif [ "$ACTION" == "2" ]; then
        flutter build apk --flavor $FLAVOR --debug
    else
        echo "Aksi tidak valid!"
        exit 1
    fi
}

while true; do
    show_menu
    read -p "Masukkan pilihan (1-5): " CHOICE
    handle_choice $CHOICE
    run_or_build
done
