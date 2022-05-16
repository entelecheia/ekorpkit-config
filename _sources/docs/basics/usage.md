---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  display_name: Python 3
  language: python
  name: python3
---

# Usage

## Via Command Line Interface (CLI)

```bash
ekorpkit --config-dir /workspace/data/ekorpkit-config/config \
    project=esgml \
    dir.workspace=/workspace \
    num_workers=1 \
    env.distributed_framework.backend=joblib \
    +corpus/builtin=_dummy_fomc_minutes \
    cmd=fetch_builtin_corpus \
    corpus.io.fetch.calculate_stats=true \
    corpus.io.fetch.preprocess_text=true \
    corpus.io.fetch.overwrite=false \
    corpus.io.fetch.force_download=false
```

### CLI Help

To see the available configurations for CLI, run the command:

```bash
ekorpkit --help
```

## Via Python

There are more examples in the [notebooks](https://github.com/entelecheia/ekorpkit-config/tree/main/notebooks) folder of the [ekorpkit-config](https://github.com/entelecheia/ekorpkit-config.git)

### Compose an ekorpkit config

```python
from ekorpkit import eKonf
cfg = eKonf.compose()
print('Config type:', type(cfg))
eKonf.pprint(cfg)
```

### Instantiating objects with an ekorpkit config

#### compose a config for the nltk class

```{code-cell} ipython3
from ekorpkit import eKonf
config_group='preprocessor/tokenizer=nltk'
cfg = eKonf.compose(config_group=config_group)
eKonf.pprint(cfg)
nltk = eKonf.instantiate(cfg)
```

```{code-cell} ipython3
text = "I shall reemphasize some of those thoughts today in the context of legislative proposals that are now before the current Congress."
nltk.tokenize(text)
```

```{code-cell} ipython3
 nltk.nouns(text)
```

#### compose a config for the mecab class

```{code-cell} ipython3
config_group='preprocessor/tokenizer=mecab'
cfg = eKonf.compose(config_group=config_group)
eKonf.pprint(cfg)
```

#### intantiate a mecab config and tokenize a text

```{code-cell} ipython3
mecab = eKonf.instantiate(cfg)
text = 'IMF가 推定한 우리나라의 GDP갭률은 今年에도 소폭의 마이너스(−)를 持續하고 있다.'
mecab.tokenize(text)
```

#### compose and instantiate a `formal_ko` config for the normalizer class

```{code-cell} ipython3
config_group='preprocessor/normalizer=formal_ko'
cfg_norm = eKonf.compose(config_group=config_group)
norm = eKonf.instantiate(cfg_norm)
norm(text)
```

#### instantiate a mecab config with the above normalizer config

```{code-cell} ipython3
config_group='preprocessor/tokenizer=mecab'
cfg = eKonf.compose(config_group=config_group)
cfg.normalize = cfg_norm
mecab = eKonf.instantiate(cfg)
mecab.tokenize(text)
```