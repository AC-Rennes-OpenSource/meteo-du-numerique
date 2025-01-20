java -jar bundletool.jar build-apks --bundle=MeteoApp_1.0.4+18_09012025.aab --output=./output_folder/output.apks --mode=universal

unzip ./output_folder/output.apks -d output_folder

adb install ./output_folder/universal.apk
