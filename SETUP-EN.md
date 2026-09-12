# D2L 英文版学习环境（跨设备）

本分支（`study`）用于在多台设备上学习 *Dive into Deep Learning* 英文版。

- `master` → 官方镜像，**不要在这里写东西**，只用来 `git merge upstream/master`
- `study` → 本分支：可运行的 notebook + 环境定义 + 自己的笔记

## 目录结构

```
environment.yml          conda 环境（Python 3.10 + d2l 1.0.3）
requirements.txt         PyTorch（CUDA 12.8 / CPU）
setup-env.sh             一键重建环境
notebooks/pytorch/       192 个可运行 notebook（来自官方 d2l-en-1.0.3.zip）
notebooks/pytorch/img/   图片资源（notebook 渲染需要）
```

## 首次在某台新设备上重建

```bash
git clone <你的 fork> d2l-en
cd d2l-en
git checkout study

bash setup-env.sh          # NVIDIA GPU
# bash setup-env.sh cpu    # 或纯 CPU
```

然后：

```bash
conda activate d2l-cu128
cd notebooks/pytorch
jupyter notebook
```

## 版本说明

| 组件 | 版本 | 备注 |
|---|---|---|
| Python | 3.10 | `d2l 1.0.3` 钉的 `numpy==1.23.5` 最高只到 cp311 |
| d2l | 1.0.3 | 与英文版正文对应 |
| torch / torchvision | 2.7.1 / 0.22.1 | **不是**官方测试的 2.0.0 |
| numpy | 1.23.5 | 被 d2l 钉死，勿手动升级 |

**为什么不用官方的 torch 2.0.0？** 该构建不含 `sm_120`（Blackwell）内核，
在 RTX 5060 上会报 `CUDA kernel error`。2.7.1 的构建同时覆盖
`sm_86 / sm_89 / sm_90 / sm_100 / sm_120`，因此 **RTX 4060 与 RTX 5060 共用同一套环境**。

## 跟进官方更新

```bash
git fetch upstream
git checkout master
git merge --ff-only upstream/master    # master 保持为纯净镜像
git push origin master
git checkout study
git merge master                       # 把官方修订带到 study
```

> 上游仓库只有 `.md` 源文件（没有 `.ipynb`），所以合并**不会**和
> `notebooks/` 里的 notebook 冲突。

## 说明与坑

- 数据集下载到 `../data`（相对于 notebook 所在目录），已在 `.gitignore` 中忽略，
  各设备会自动重新下载，**不需要同步**。
- 第 2 台设备若**没有 NVIDIA 独显**，用 `bash setup-env.sh cpu`。
- 如果仓库体积增长过快（notebook 带输出反复提交），可安装 `nbstripout`
  让提交时自动剥离输出：
  ```bash
  pip install nbstripout && nbstripout --install
  ```
