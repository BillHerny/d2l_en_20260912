# 从哪开始？

> 这个仓库里有**两套同名目录树**，很容易找错地方。看这里 30 秒就能分清。

## 1. 要跑代码 → 去 `notebooks/pytorch/`

```
notebooks/pytorch/
├── chapter_convolutional-modern/
│   ├── resnet.ipynb        ← 能跑的
│   ├── densenet.ipynb
│   └── ...
├── chapter_reinforcement-learning/    ← 英文版新增章节
├── chapter_gaussian-processes/        ← 英文版新增章节
├── chapter_hyperparameter-optimization/ ← 英文版新增章节
├── chapter_generative-adversarial-networks/
├── chapter_recommender-systems/
├── chapter_appendix-mathematics-for-deep-learning/
└── ...
```

共 192 个 `.ipynb`。

## 2. ⚠️ 根目录下的 `chapter_*/` **不能运行**

```
chapter_convolutional-modern/
└── resnet.md      ← 只有 markdown，没有代码单元格
```

那是官方 git 仓库的**源文件**（用 `:begin_tab:` 做多框架切换，由 d2lbook 构建成 notebook）。
它存在的意义是：跟随官方更新（`git merge upstream/master`）、给官方提 PR、查改历史。
**学习时不用打开它。**

## 3. 怎么跑

```bash
conda activate d2l-cu128
cd notebooks/pytorch
jupyter notebook
```

或者在 VS Code 里直接打开 `.ipynb`，右上角 kernel 选 **`d2l-cu128`**（Python 3.10）。

> ⚠️ 不要选 `LimuDeeplearning_py3.8` —— 那个环境的 torch 在 RTX 4060/5060 上跑不了 GPU 内核。

## 4. 环境重建（换设备时）

见 `SETUP-EN.md`，或直接：

```bash
bash setup-env.sh          # NVIDIA GPU
bash setup-env.sh cpu      # 纯 CPU
```

## 5. 跟进官方更新

```bash
git fetch upstream
git checkout master && git merge --ff-only upstream/master && git push origin master
git checkout study && git merge master
```

上游只有 `.md`，**不含 `.ipynb`**，所以合并不会和 `notebooks/` 冲突。
