# ekorpkit[iːkɔːkɪt]: (e)nglish (K)orean C(orp)us Tool(kit)

[![PyPI version](https://badge.fury.io/py/ekorpkit.svg)](https://badge.fury.io/py/ekorpkit) [![Jupyter Book Badge](https://jupyterbook.org/en/stable/_images/badge.svg)](https://entelecheia.github.io/ekorpkit-config/) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6497226.svg)](https://doi.org/10.5281/zenodo.6497226) [![pages-build-deployment](https://github.com/entelecheia/ekorpkit-config/actions/workflows/pages/pages-build-deployment/badge.svg?branch=gh-pages)](https://github.com/entelecheia/ekorpkit-config/actions/workflows/pages/pages-build-deployment)

eKorpkit provides a flexible interface for corpus management and analysis pipelines such as extraction, transformation, tokenization, training, and visualization.

- Powerful config composition backed by [Hydra](https://hydra.cc/) - Easily swap out corpora, datasets, models, preprocessors, visualizers and many more configurations without touching the code.

## [Tutorials](https://entelecheia.github.io/ekorpkit-config)

Tutorials for [ekorpkit](https://github.com/entelecheia/ekorpkit) package can be found at https://entelecheia.github.io/ekorpkit-config/

## [Installation](https://entelecheia.github.io/ekorpkit-config/docs/about/install.html)

Install the latest version of ekorpit:

```bash
pip install ekorpkit
```

To install all extra dependencies,

```bash
pip install ekorpkit[all]
```

## Citation

```tex
@software{lee_2022_6497226,
  author       = {Young Joon Lee},
  title        = {eKorpkit: English Korean Corpus Toolkit},
  month        = apr,
  year         = 2022,
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.6497226},
  url          = {https://doi.org/10.5281/zenodo.6497226}
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

## License

- eKorpkit is licensed under the Creative Commons License(CCL) 4.0 [CC-BY](https://creativecommons.org/licenses/by/4.0). This license covers the eKorpkit package and all of its components.
- Each corpus adheres to its own license policy. Please check the license of the corpus before using it!
