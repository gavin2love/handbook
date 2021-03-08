新装ESXI7发下SWAP缓存被自动设置了128G，且无法回滚设置。只能新装

在启动显示界面时在3秒内按下 SHIFT+O 组合键（字母O不是数字0）即可修改引导选项。

在最后加上 autoPartitionOSDataSize 参数即可定制虚拟闪存大小。

	<ENTER: Apply options and boot>
	> cdromBoot runweasel autoPartitionOSDataSize=8192
注意：默认已有 cdromBoot runweasel 段，务必需要在后面加上空格分隔参数！！默认单位为 MB ，例子为分配 8G，毕竟磁盘只有可怜的 240GB 容量。