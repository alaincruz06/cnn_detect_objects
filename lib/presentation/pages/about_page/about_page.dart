import 'package:cnn_detect_objects/presentation/app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getInfo(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  foregroundImage: AssetImage(
                                    Assets.assetsImagesAppLogo,
                                  ),
                                  radius: 35,
                                )),
                            Text(
                              "${snapshot.data?.elementAt(0)}",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              "${snapshot.data?.elementAt(2)}",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Aplicación móvil desarrollada para el curso Técnicas avanzadas de Inteligencia Artificial de la Maestría en Informática Avanzada.",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Desarrollador:',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Text(
                          'Alain Cruz Jiménez',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Gmail
                              InkWell(
                                onTap: () async {
                                  final Uri params = Uri(
                                    scheme: 'mailto',
                                    path: 'alaincruz06@gmail.com',
                                    query:
                                        'subject=Acerca de ${snapshot.data?.elementAt(0)} ${snapshot.data?.elementAt(2)}',
                                  );
                                  launchUrl(params,
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        Assets.assetsIconsGmail192px,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              //Telegram
                              InkWell(
                                onTap: () {
                                  Uri uriTelegram = Uri(
                                    scheme: 'https',
                                    host: 'telegram.me',
                                    path: '/alaincruz06',
                                  );
                                  launchUrl(uriTelegram,
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        Assets.assetsIconsTelegram96px,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              //Apklis
                              InkWell(
                                onTap: () {
                                  Uri uriApklis = Uri(
                                    scheme: 'https',
                                    host: 'apklis.cu',
                                    path: '/developer/alaincj',
                                  );
                                  launchUrl(uriApklis,
                                      mode: LaunchMode.externalApplication);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                    // shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                        Assets.assetsIconsApklisLogo,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<List<String>> getInfo() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  final String appName = packageInfo.appName;
  final String packageName = packageInfo.packageName;
  final String version = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;

  return [appName, packageName, version, buildNumber];
}
