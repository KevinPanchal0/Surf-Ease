import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:surf_ease/model/bookmark_modal.dart';
import 'package:surf_ease/provider/bookmark_provider.dart';
import 'package:surf_ease/provider/connectivity_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late InAppWebViewController inAppWebViewController;
  late PullToRefreshController pullToRefreshController;
  bool canGoBack = false;
  bool canGoForward = false;

  String? url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.deepOrange),
      onRefresh: () async {
        inAppWebViewController.reload();
      },
    );
    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (Provider.of<ConnectivityProvider>(context)
                        .connectivityModal
                        .isNetworkAvailable ==
                    false)
                ? Center(
                    child: Column(
                    children: [
                      Lottie.asset('assets/animations/animation.json',
                          height: 200),
                      const Text('No Internet'),
                      const Text('Check Your Connectivity'),
                    ],
                  ))
                : Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 12,
                          child: InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: WebUri('https://google.com/'),
                            ),
                            onWebViewCreated: (controller) {
                              inAppWebViewController = controller;
                            },
                            pullToRefreshController: pullToRefreshController,
                            onLoadStart: (controller, _) async {
                              canGoBack =
                                  await inAppWebViewController.canGoBack();
                              canGoForward =
                                  await inAppWebViewController.canGoForward();
                              setState(() {});
                            },
                            onLoadStop: (controller, url) async {
                              canGoBack =
                                  await inAppWebViewController.canGoBack();
                              canGoForward =
                                  await inAppWebViewController.canGoForward();
                              pullToRefreshController.endRefreshing();
                              setState(() {});
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  await inAppWebViewController.loadUrl(
                                      urlRequest: URLRequest(
                                          url: WebUri('https://google.com/')));

                                  setState(() {
                                    canGoForward = false;
                                    canGoBack = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.home_outlined,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  String? tittle =
                                      await inAppWebViewController.getTitle();
                                  WebUri? url =
                                      await inAppWebViewController.getUrl();

                                  Provider.of<BookmarkProvider>(context,
                                          listen: false)
                                      .addBookMark(BookmarkModal(
                                          tittle: tittle!, url: url!));
                                  final snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.only(bottom: 80),
                                    action: SnackBarAction(
                                      label: 'Go',
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed('bookMark');
                                      },
                                    ),
                                    content: const Text('BookMark Added'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                icon: const Icon(
                                  Icons.bookmark_border_outlined,
                                ),
                              ),
                              PopScope(
                                canPop: false,
                                onPopInvoked: (didPop) {
                                  if (didPop) {
                                    return;
                                  }
                                  (canGoBack == true)
                                      ? backward()
                                      : showDialogBox();
                                },
                                child: IconButton(
                                  onPressed:
                                      (canGoBack == true) ? backward : null,
                                  icon: const Icon(
                                    Icons.chevron_left,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await inAppWebViewController.reload();
                                },
                                icon: const Icon(
                                  Icons.refresh_outlined,
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    (canGoForward == true) ? forward : null,
                                icon: const Icon(
                                  Icons.chevron_right,
                                ),
                              ),
                              PopupMenuButton(
                                elevation: 2,
                                offset: const Offset(0, -80),
                                onSelected: (value) async {
                                  if (value == 1) {
                                    final result = await Navigator.of(context)
                                        .pushNamed('bookMark');
                                    if (result != null && result is WebUri) {
                                      setState(() {
                                        url = result.toString();
                                      });
                                      inAppWebViewController.loadUrl(
                                          urlRequest:
                                              URLRequest(url: WebUri(url!)));
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.bookmark_border_outlined),
                                        Text('BookMarks'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void backward() async {
    await inAppWebViewController.goBack();
  }

  void forward() async {
    await inAppWebViewController.goForward();
  }

  void showDialogBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Are you Sure?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ActionChip(
                  label: const Text('Exit'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ));
  }
}
