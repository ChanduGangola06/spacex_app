import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spacex_app/core/utils/responsive_helper.dart';

class RocketDetail extends StatelessWidget {
  final Map<String, dynamic> rocketData;

  const RocketDetail({super.key, required this.rocketData});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: isTablet ? 300.h : 200.h,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey[900],
                    child: Icon(
                      Icons.rocket_launch,
                      size: 64.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Semantics(
              button: true,
              label: 'Go back',
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: ResponsiveHelper.getAdaptivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            rocketData['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.getAdaptiveFontSize(
                                  context, 24.sp),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: rocketData['active']
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          rocketData['active'] ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: rocketData['active']
                                ? Colors.green
                                : Colors.red,
                            fontSize: ResponsiveHelper.getAdaptiveFontSize(
                                context, 14.sp),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context)),
                  _buildSection(
                    context,
                    'Overview',
                    [
                      _buildInfoRow(
                        context,
                        'Type',
                        rocketData['type'],
                        Icons.category,
                      ),
                      _buildInfoRow(
                        context,
                        'Company',
                        rocketData['company'],
                        Icons.business,
                      ),
                      _buildInfoRow(
                        context,
                        'Country',
                        rocketData['country'],
                        Icons.public,
                      ),
                      _buildInfoRow(
                        context,
                        'First Flight',
                        rocketData['first_flight'],
                        Icons.flight_takeoff,
                      ),
                    ],
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context)),
                  _buildSection(
                    context,
                    'Specifications',
                    [
                      _buildInfoRow(
                        context,
                        'Cost per Launch',
                        '\$${rocketData['cost_per_launch']}',
                        Icons.attach_money,
                      ),
                      _buildInfoRow(
                        context,
                        'Success Rate',
                        '${rocketData['success_rate_pct']}%',
                        Icons.check_circle_outline,
                      ),
                      _buildInfoRow(
                        context,
                        'Stages',
                        rocketData['stages'].toString(),
                        Icons.layers,
                      ),
                      _buildInfoRow(
                        context,
                        'Boosters',
                        rocketData['boosters'].toString(),
                        Icons.rocket,
                      ),
                    ],
                  ),
                  if (rocketData['description'] != null) ...[
                    SizedBox(
                        height: ResponsiveHelper.getAdaptiveSpacing(context)),
                    _buildSection(
                      context,
                      'Description',
                      [
                        Text(
                          rocketData['description'],
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: ResponsiveHelper.getAdaptiveFontSize(
                                context, 16.sp),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (rocketData['wikipedia'] != null) ...[
                    SizedBox(
                        height: ResponsiveHelper.getAdaptiveSpacing(context)),
                    _buildSection(
                      context,
                      'Links',
                      [
                        _buildLinkButton(
                          context,
                          'Wikipedia',
                          rocketData['wikipedia'],
                          Icons.language,
                        ),
                      ],
                    ),
                  ],
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context) * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.getAdaptiveFontSize(context, 20.sp),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
        Container(
          padding: EdgeInsets.all(ResponsiveHelper.getAdaptiveSpacing(context)),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getAdaptiveFontSize(context, 20.sp),
            color: Colors.grey[400],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: label,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize:
                          ResponsiveHelper.getAdaptiveFontSize(context, 14.sp),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Semantics(
                  label: '$label value: $value',
                  child: Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? Colors.white,
                      fontSize:
                          ResponsiveHelper.getAdaptiveFontSize(context, 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String label,
    String url,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
      child: Semantics(
        button: true,
        label: 'Open $label',
        child: InkWell(
          onTap: () => Get.to(() => WebView(url: url)),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: ResponsiveHelper.getAdaptiveFontSize(context, 20.sp),
                  color: Colors.white,
                ),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ResponsiveHelper.getAdaptiveFontSize(context, 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WebView extends StatelessWidget {
  final String url;

  const WebView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Semantics(
          button: true,
          label: 'Go back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
        title: Semantics(
          header: true,
          child: const Text(
            'Web View',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Web View URL: $url',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
