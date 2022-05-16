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

(file-types:myst-notebooks)=
# Installation

Install the latest version of ekorpit:

```bash
pip install -U ekorpkit
```

To install all extra dependencies,

```bash
pip install ekorpkit[all]
```

## Extra dependency keys

```{code-cell} ipython3
from ekorpkit import eKonf

eKonf.dependencies("keys")
```

### Extra dependencies

- all

```{code-cell} ipython3
from ekorpkit import eKonf

eKonf.dependencies("all")
```

- tokenize

```{code-cell} ipython3
from ekorpkit import eKonf

eKonf.dependencies("tokenize")
```
