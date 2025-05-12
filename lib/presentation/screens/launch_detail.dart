// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spacex_app/core/utils/responsive_helper.dart';

class LaunchDetail extends StatelessWidget {
  final Map<String, dynamic> launchData;

  const LaunchDetail({super.key, required this.launchData});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final isLandscape = ResponsiveHelper.isLandscape(context);
    final rocketName = launchData['rocket']?['rocket_name'] ?? 'Unknown Rocket';
    final launchDate = launchData['launch_date_utc'];
    final launchSite =
        launchData['launch_site']?['site_name'] ?? 'Unknown Site';
    final launchSuccess = launchData['launch_success'] ?? false;
    final rocketType = launchData['rocket']?['rocket_type'] ?? 'Unknown Type';
    final details = launchData['details'];
    final links = launchData['links'];

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
                  if (links?['flickr_images']?.isNotEmpty ?? false)
                    Image.network(
                      links['flickr_images'][0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: Icon(
                            Icons.rocket_launch,
                            size: 64.sp,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    )
                  else
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
                          // ignore: deprecated_member_use
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
                  Semantics(
                    header: true,
                    child: Text(
                      rocketName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.getAdaptiveFontSize(
                            context, 24.sp),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context) / 2),
                  if (launchDate != null)
                    _buildInfoRow(
                      context,
                      'Launch Date',
                      DateTime.parse(launchDate).toString().split('.')[0],
                      Icons.calendar_today,
                    ),
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context)),
                  _buildSection(
                    context,
                    'Mission Details',
                    [
                      if (details != null)
                        _buildInfoRow(
                          context,
                          'Description',
                          details,
                          Icons.info_outline,
                        ),
                      _buildInfoRow(
                        context,
                        'Launch Site',
                        launchSite,
                        Icons.location_on,
                      ),
                      _buildInfoRow(
                        context,
                        'Mission Status',
                        launchSuccess ? 'Successful' : 'Failed',
                        Icons.check_circle_outline,
                        valueColor: launchSuccess ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(
                      height: ResponsiveHelper.getAdaptiveSpacing(context)),
                  _buildSection(
                    context,
                    'Rocket Information',
                    [
                      _buildInfoRow(
                        context,
                        'Rocket Name',
                        rocketName,
                        Icons.rocket,
                      ),
                      _buildInfoRow(
                        context,
                        'Rocket Type',
                        rocketType,
                        Icons.category,
                      ),
                    ],
                  ),
                  if (links != null) ...[
                    SizedBox(
                        height: ResponsiveHelper.getAdaptiveSpacing(context)),
                    _buildSection(
                      context,
                      'Links',
                      [
                        if (links['wikipedia'] != null)
                          _buildLinkButton(
                            context,
                            'Wikipedia',
                            links['wikipedia'],
                            Icons.language,
                          ),
                        if (links['video_link'] != null)
                          _buildLinkButton(
                            context,
                            'Watch Video',
                            links['video_link'],
                            Icons.play_circle_outline,
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
        ...children,
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
