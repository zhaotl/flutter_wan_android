PHONY: run_dev run_dev_ios run_dev_android run_prod build_dev_apk build_prod_apk

FLAVOR_DEV=lib/main_dev.dart
FLAVOR_QA=lib/main_test.dart

run_dev:
	flutter run -t ${FLAVOR_DEV} --flavor dev 

# -d 后面跟的事设备的 id， 通过 flutter devices 查询， 根据实际的加入
run_dev_ios: 
	flutter run -t ${FLAVOR_DEV} --flavor dev -d 59b2a30e8b1edcc60809265090431cd1d9debeeb

# -d 后面跟的事设备的 id， 通过 flutter devices 查询， 根据实际的加入
run_dev_android:
	flutter run -t ${FLAVOR_DEV} --flavor dev -d rgvorccehepfpb5h

run_qa:
	flutter run -t ${FLAVOR_QA} --flavor qa 

build_dev_apk:
	flutter build apk -t ${FLAVOR_DEV} --flavor dev

build_qa_apk:
	flutter build apk -t ${FLAVOR_QA} --flavor qa