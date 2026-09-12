#!/usr/bin/env bash
# 一键重建 D2L 英文版学习环境
#
#   bash setup-env.sh         # NVIDIA GPU（CUDA 12.8 wheel）
#   bash setup-env.sh cpu     # 纯 CPU 机型
#
# 可重复执行：环境已存在时会跳过创建，只补装/校验 PyTorch。

set -euo pipefail

ENV_NAME=d2l-cu128
MODE="${1:-cuda}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== 1/3 创建 conda 环境（$ENV_NAME）==="
if conda env list | grep -qE "^${ENV_NAME}[[:space:]]"; then
  echo "  已存在，跳过创建"
  echo "  （如需彻底重建：conda env remove -n $ENV_NAME 后重跑本脚本）"
else
  conda env create -f "$HERE/environment.yml"
fi

echo "=== 2/3 安装 PyTorch（$MODE）==="
if [ "$MODE" = "cpu" ]; then
  IDX=https://download.pytorch.org/whl/cpu
  echo "  使用 CPU 索引：$IDX"
else
  IDX=https://download.pytorch.org/whl/cu128
  echo "  使用 CUDA 12.8 索引：$IDX"
fi
conda run -n "$ENV_NAME" pip install --quiet \
  torch==2.7.1 torchvision==0.22.1 --index-url "$IDX"

echo "=== 3/3 自检 ==="
conda run -n "$ENV_NAME" python -c '
import torch, d2l, numpy, matplotlib, pandas, scipy
print("  torch       ", torch.__version__, "| cuda build:", torch.version.cuda)
print("  cuda 可用   ", torch.cuda.is_available())
if torch.cuda.is_available():
    print("  设备        ", torch.cuda.get_device_name(0))
    print("  编译架构    ", torch.cuda.get_arch_list())
    x = torch.randn(512, 512, device="cuda")
    print("  GPU 计算    ", float((x @ x).sum()))
print("  d2l         ", d2l.__version__)
print("  numpy       ", numpy.__version__)
print("  matplotlib  ", matplotlib.__version__)
print("  pandas      ", pandas.__version__, "| scipy:", scipy.__version__)
'

echo
echo "完成。启动笔记本（在 notebooks/pytorch/ 下）："
echo "  conda activate $ENV_NAME && jupyter notebook"
