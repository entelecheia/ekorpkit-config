# ekorpkit-config

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6497227.svg)](https://doi.org/10.5281/zenodo.6497227)

Config files for [ekorpkit](https://github.com/entelecheia/ekorpkit) package

## Use Cases

### Topic Model

- [Topic coverage in the analyst reports](docs/usecases/esg_topics/anlalyst.md)
- Topic coverage in the media
- Topic coverage in the corporate disclosure

### Classification

- ESG Ratings
- Monetray Policy Tones

### Named Entity Regcognition

- Bio-medical NER

## Installation

Install the latest version of ekorpit:

```bash
pip install ekorpkit
```

Clone the ekorpkit-config

```bash
git clone https://github.com/entelecheia/ekorpkit-config.git
```

## Usage

### Via Command Line Interface (CLI)

```bash
ekorpkit --config-dir /workspace/data/ekorpkit-config/config \
    project=esgml \
    dir.workspace=/workspace \
    num_workers=1 \
    env.distributed_framework.backend=joblib \
    +corpus/builtin=_dummy_fomc_minutes \
    cmd=fetch_builtin_corpus \
    corpus.builtin.fetch.calculate_stats=true \
    corpus.builtin.fetch.preprocess_text=true \
    corpus.builtin.fetch.overwrite=false \
    corpus.builtin.fetch.force_download=false
```

#### CLI Help

To see the available configurations for CLI, run the command:

```bash
ekorpkit --help
```

### Via Shell Script `run.sh`

There are more examples in the [usage](https://github.com/entelecheia/ekorpkit-config/blob/main/usage.md) file of the [ekorpkit-config](https://github.com/entelecheia/ekorpkit-config.git)

#### Corpus tasks

```bash
bash run.sh corpus -t corpus_sample -c nikl_news
bash run.sh corpus -t corpus_sample -c aihub_book
```

#### Finetune a simple classification model

```bash
bash run.sh finetune -t simple_classification -c esg_topics
bash run.sh finetune -t simple_classification -c finphrase_kr
```

### Via Python

There are more examples in the [notebooks](https://github.com/entelecheia/ekorpkit-config/tree/main/notebooks) folder of the [ekorpkit-config](https://github.com/entelecheia/ekorpkit-config.git)

#### Compose an ekorpkit config

```python
# import ekorpkit.ekonf as eKonf
from ekorpkit import eKonf
from pprint import pprint

cfg = eKonf.compose()
print('Config type:', type(cfg))
pprint(cfg)
```

#### Instantiating objects with an ekorpkit config

- compose a config for the mecab class

```python
config_group='preprocessor/tokenizer=mecab'
cfg = eKonf.compose(config_group=config_group)
pprint(cfg)
```

```python
{'_target_': 'ekorpkit.preprocessors.tokenizer.MecabTokenizer',
 'extract': {'no_space_for_non_nouns': False,
             'noun_postags': ['NNG', 'NNP', 'XSN', 'SL', 'XR', 'NNB', 'NR'],
             'stop_postags': ['SP'],
             'stopwords': None,
             'stopwords_path': None},
 'mecab': {'backend': 'mecab-python3', 'userdic_path': None, 'verbose': False},
 'normalize': None,
 'tokenize': {'concat_surface_and_pos': True,
              'flatten': True,
              'include_whitespace_token': True,
              'lowercase': False,
              'punct_postags': ['SF', 'SP', 'SSO', 'SSC', 'SY'],
              'tokenize_each_word': False,
              'userdic_path': None,
              'wordpieces_prefix': '##'},
 'tokenize_article': {'return_typ': 'str', 'sentence_separator': '\\n'},
 'verbose': False}
```

- intantiate a mecab config and tokenize a text

```python
mecab = eKonf.instantiate(cfg)
text = 'IMF가 推定한 우리나라의 GDP갭률은 今年에도 소폭의 마이너스(−)를 持續하고 있다.'
mecab.tokenize(text)
```

> ['IMF/SL', '가/JKS', ' /SP', '推定/NNG', '한/XSA+ETM', ' /SP', '우리나라/NNG', '의/JKG', ' /SP', 'GDP/SL', '갭/NNG', '률/XSN', '은/JX', ' /SP', '今年/NNG', '에/JKB', '도/JX', ' /SP', '소폭/NNG', '의/JKG', ' /SP', '마이너스/NNG', '(/SSO', '−)/SY', '를/JKO', ' /SP', '持續/NNG', '하/XSV', '고/EC', ' /SP', '있/VX', '다/EF', './SF']

- compose and instantiate a `formal_ko` config for the normalizer class

```python
config_group='preprocessor/normalizer=formal_ko'
cfg_norm = eKonf.compose(config_group=config_group)
norm = eKonf.instantiate(cfg_norm)
norm(text)
```

> 'IMF가 추정한 우리나라의 GDP갭률은 금년에도 소폭의 마이너스(-)를 지속하고 있다.'

- instantiate a mecab config with the above normalizer config

```python
config_group='preprocessor/tokenizer=mecab'
cfg = eKonf.compose(config_group=config_group)
cfg['normalize'] = cfg_norm
mecab = eKonf.instantiate(cfg)
mecab.tokenize(text)
```

> ['IMF/SL', '가/JKS', ' /SP', '추정/NNG', '한/XSA+ETM', ' /SP', '우리나라/NNG', '의/JKG', ' /SP', 'GDP/SL', '갭/NNG', '률/XSN', '은/JX', ' /SP', '금년/NNG', '에/JKB', '도/JX', ' /SP', '소폭/NNG', '의/JKG', ' /SP', '마이너스/NNG', '(/SSO', '-)/SY', '를/JKO', ' /SP', '지속/NNG', '하/XSV', '고/EC', ' /SP', '있/VX', '다/EF', './SF']


## Citation

```tex
@software{lee_2022_6497227,
  author       = {Young Joon Lee},
  title        = {eKorpkit: English Korean Corpus Toolkit},
  month        = apr,
  year         = 2022,
  publisher    = {Zenodo},
  version      = {0.1.23},
  doi          = {10.5281/zenodo.6497227},
  url          = {https://doi.org/10.5281/zenodo.6497227}
}
```

```tex
@software{lee_2022_ekorpkit,
  author       = {Young Joon Lee},
  title        = {eKorpkit: English Korean Corpus Toolkit},
  month        = apr,
  year         = 2022,
  publisher    = {GitHub},
  url          = {https://github.com/entelecheia/ekorpkit}
}
```
