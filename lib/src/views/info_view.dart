import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class InfoView extends StatefulWidget {
  InfoView({Key? key}) : super(key: key);

  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView>
    with AutomaticKeepAliveClientMixin {
  PackageInfo? packageInfo;
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;

  Future getAllInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    packageInfo = await PackageInfo.fromPlatform();
    if (Platform.isAndroid) androidInfo = await deviceInfo.androidInfo;
    if (Platform.isIOS) iosInfo = await deviceInfo.iosInfo;
  }

  bool get infoWell =>
      packageInfo != null && (androidInfo != null || iosInfo != null);

  _buildGridItem(String title, String subTitle) {
    return MaterialButton(
      elevation: 2,
      onPressed: () {},
      onLongPress: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Clipboard.setData(ClipboardData(text: subTitle));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('已复制'),
          action: SnackBarAction(
            label: '确定',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            AutoSizeText(
              subTitle,
              style: TextStyle(fontSize: 26),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  _buildTile(String title, String? subTitle) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.black),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subTitle ?? ''),
        onLongPress: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Clipboard.setData(ClipboardData(text: subTitle));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('已复制'),
            action: SnackBarAction(
              label: '确定',
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          ));
        },
      ),
    );
  }

  _buildAndroidList() {
    return SliverList(
        delegate: SliverChildListDelegate([
      _buildTile('androidId', androidInfo!.androidId),
      _buildTile('board', androidInfo!.board),
      _buildTile('bootloader', androidInfo!.bootloader),
      _buildTile('brand', androidInfo!.brand),
      _buildTile('device', androidInfo!.device),
      _buildTile('display', androidInfo!.display),
      _buildTile('fingerprint', androidInfo!.fingerprint),
      _buildTile('hardware', androidInfo!.hardware),
      _buildTile('host', androidInfo!.host),
      _buildTile('id', androidInfo!.id),
      _buildTile('manufacturer', androidInfo!.manufacturer),
      _buildTile('model', androidInfo!.model),
      _buildTile('product', androidInfo!.product),
      _buildTile('tags', androidInfo!.tags),
      _buildTile('type', androidInfo!.type),
      _buildTile('isPhysicalDevice', androidInfo!.isPhysicalDevice.toString()),
      _buildTile(
          'supported32BitAbis', androidInfo!.supported32BitAbis.join(',')),
      _buildTile(
          'supported64BitAbis', androidInfo!.supported64BitAbis.join(',')),
      _buildTile('supportedAbis', androidInfo!.supportedAbis.join(',')),
      _buildTile('baseOS', androidInfo!.version.baseOS),
      _buildTile('codename', androidInfo!.version.codename),
      _buildTile('incremental', androidInfo!.version.incremental),
      _buildTile('release', androidInfo!.version.release),
      _buildTile('securityPatch', androidInfo!.version.securityPatch),
      _buildTile(
          'previewSdkInt', androidInfo!.version.previewSdkInt.toString()),
      _buildTile('sdkInt', androidInfo!.version.sdkInt.toString()),
      _buildTile('systemFeatures', androidInfo!.systemFeatures.join('\n')),
    ]));
  }

  _buildIOSList() {
    return SliverList(
        delegate: SliverChildListDelegate([
      _buildTile('identifierForVendor', iosInfo!.identifierForVendor),
      _buildTile('localizedModel', iosInfo!.localizedModel),
      _buildTile('model', iosInfo!.model),
      _buildTile('name', iosInfo!.name),
      _buildTile('systemName', iosInfo!.systemName),
      _buildTile('systemVersion', iosInfo!.systemVersion),
      _buildTile('isPhysicalDevice', iosInfo!.isPhysicalDevice.toString()),
      _buildTile('machine', iosInfo!.utsname.machine),
      _buildTile('nodename', iosInfo!.utsname.nodename),
      _buildTile('release', iosInfo!.utsname.release),
      _buildTile('sysname', iosInfo!.utsname.sysname),
      _buildTile('version', iosInfo!.utsname.version),
    ]));
  }

  _buildView() {
    if (Platform.isAndroid) return _buildAndroidList();
    if (Platform.isIOS)
      return _buildIOSList();
    else
      return SliverToBoxAdapter(child: Text('不支持的平台'));
  }

  @override
  void initState() {
    super.initState();
    getAllInfo().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return infoWell
        ? CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(5),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildGridItem('appName', packageInfo!.appName),
                    _buildGridItem('buildNumber', packageInfo!.buildNumber),
                    _buildGridItem('packageName', packageInfo!.packageName),
                    _buildGridItem('version', packageInfo!.version),
                  ],
                ),
              ),
              _buildView(),
            ],
          )
        : ListView();
  }

  @override
  bool get wantKeepAlive => true;
}
