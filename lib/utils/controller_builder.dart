import 'package:flutter/material.dart';

typedef ControllerBuilder<T extends ChangeNotifier> = Widget Function(
    BuildContext, T);
typedef ControllerListener<T extends ChangeNotifier> = void Function(T);

class ControllerProvider<T extends ChangeNotifier> extends StatefulWidget {
  const ControllerProvider({
    Key key,
    this.controller,
    this.controllerListener,
    this.builder,
  }) : super(key: key);

  final T controller;
  final ControllerListener<T> controllerListener;
  final ControllerBuilder<T> builder;

  @override
  State<ControllerProvider<T>> createState() => ControllerProviderState<T>();
}

class ControllerProviderState<T extends ChangeNotifier>
    extends State<ControllerProvider<T>> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    widget.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        widget.controller,
      );

  void _controllerListener() => widget.controllerListener(widget.controller);
}
