import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/extensions/context.dart';
import 'package:wave/providers/device_info.dart';

class ApplicationInfo extends StatelessWidget {
  const ApplicationInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceInfoController>(
      builder: (context, device, child) {
        return device.sdkInt != null
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.translated.systemVersion,
                        style: context.textTheme.bodySmall,
                      ),
                      Text(
                        '${device.release} (${device.sdkInt})',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.translated.device,
                        style: context.textTheme.bodySmall,
                      ),
                      Text(
                        '${device.manufacturer} ${device.brand} (${device.model})',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        device.product != '' ? context.translated.product : '',
                        style: context.textTheme.bodySmall,
                      ),
                      Text(
                        device.product ?? '',
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
