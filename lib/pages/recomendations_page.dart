import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:smart/bloc_files/recomedations_bloc.dart';
import 'package:smart/core/constants/text_styles.dart';
import 'package:smart/models/assortments_list_model.dart';
import '../core/constants/source.dart';
import '../custom_widgets/recomedation_item_card.dart';

import '../utils/controller_builder.dart';

class RecomendationsPage extends StatelessWidget {
  const RecomendationsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<RecomendationsBloc>(
        create: (context) => RecomendationsBloc()
          ..add(
            RecomendationsLoadEvent(),
          ),
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: mainGradient),
            child: Column(
              children: [
                RecomendationsAppBar(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          heightRatio(size: 15, context: context),
                        ),
                      ),
                    ),
                    child: BlocBuilder<RecomendationsBloc, RecomendationsState>(
                      builder: blocBuilder,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget blocBuilder(BuildContext context, RecomendationsState state) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double childAspectRatio = screenWidth <= 385
        ? screenWidth <= 34
            ? 0.75 //small phone там широко и расстяния по вертикали увеличены
            : 0.64 //samsung a54
        : 0.61;

    if (state is RecomendationsInitState ||
        state is RecomendationsLoadingState) {
      return Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    if (state is RecomendationsErrorState) {
      return const ErrorRecomendations();
    }
    if (state.recomList.isEmpty) {
      return const EmptyRecomendations();
    }
    return ControllerProvider<ScrollController>(
      controller: ScrollController(),
      controllerListener: (controller) => _controllerListener(
        context,
        controller,
      ),
      builder: (context, controller) {
        return GridView.count(
          controller: controller,
          childAspectRatio: childAspectRatio,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: heightRatio(size: 16, context: context),
            left: widthRatio(size: 16, context: context),
            right: widthRatio(size: 16, context: context),
          ),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          crossAxisCount: 2,
          children: state.recomList
              .map(
                (AssortmentsListModel assortment) =>
                    RecomendationsItemCard(recomendation: assortment),
              )
              .toList(),
        );
      },
    );
  }

  void _controllerListener(BuildContext context, ScrollController controller) {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      context.read<RecomendationsBloc>().add(RecomendationsNextPageEvent());
    }
  }
}

class RecomendationsAppBar extends StatelessWidget {
  const RecomendationsAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: heightRatio(size: 12, context: context),
          right: widthRatio(size: 17, context: context),
          left: widthRatio(size: 12, context: context),
          top: heightRatio(size: 4, context: context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.only(
                left: widthRatio(size: 2, context: context),
                right: widthRatio(size: 5, context: context),
              ),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: heightRatio(size: 22, context: context),
                color: whiteColor,
              ),
            ),
            SizedBox(width: widthRatio(size: 8, context: context)),
            Expanded(
              child: Text(
                "addToOrder".tr(),
                style: appLabelTextStyle(
                  color: Colors.white,
                  fontSize: heightRatio(size: 22, context: context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorRecomendations extends StatelessWidget {
  const ErrorRecomendations({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(
            widthRatio(size: 15, context: context),
          ),
          decoration: const BoxDecoration(
            color: colorBlack03,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/images/netErrorIcon.svg',
            color: Colors.white,
            height: heightRatio(
              size: 30,
              context: context,
            ),
          ),
        ),
        SizedBox(
          height: heightRatio(size: 15, context: context),
        ),
        Text(
          "errorText".tr(),
          style: appTextStyle(
            fontSize: heightRatio(size: 18, context: context),
            color: colorBlack06,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: heightRatio(size: 10, context: context),
        ),
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              heightRatio(size: 14, context: context),
            ),
          ),
          child: InkWell(
            onTap: () => context
                .read<RecomendationsBloc>()
                .add(RecomendationsLoadEvent()),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widthRatio(size: 8, context: context),
                vertical: heightRatio(size: 8, context: context),
              ),
              child: Text(
                "tryAgainText".tr(),
                style: appTextStyle(
                  fontSize: heightRatio(
                    size: 14,
                    context: context,
                  ),
                  color: mainColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class EmptyRecomendations extends StatelessWidget {
  const EmptyRecomendations({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(
            widthRatio(size: 15, context: context),
          ),
          decoration: BoxDecoration(
            color: colorBlack03,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/images/closeCircleIcon.svg',
            color: Colors.white,
            height: heightRatio(
              size: 30,
              context: context,
            ),
          ),
        ),
        SizedBox(
          height: heightRatio(size: 15, context: context),
        ),
        Text(
          "seemsThereIsNothing".tr(),
          style: appTextStyle(
            fontSize: heightRatio(size: 18, context: context),
            color: colorBlack06,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: heightRatio(size: 10, context: context),
        ),
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              heightRatio(size: 14, context: context),
            ),
          ),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widthRatio(size: 8, context: context),
                vertical: heightRatio(size: 8, context: context),
              ),
              child: Text(
                "understandable".tr(),
                style: appTextStyle(
                  fontSize: heightRatio(
                    size: 14,
                    context: context,
                  ),
                  color: mainColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
