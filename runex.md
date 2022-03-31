# Examples

## Corpus tasks

```bash
bash run.sh corpus -t corpus_sample -c nikl_news 
bash run.sh corpus -t corpus_sample -c aihub_book
```

## Build a corpus

```bash
bash run.sh build_corpus -c aihub_book
```
## Build a dataset for simpletransformers

```bash
bash run.sh build_simple -c esg_topics
```

## Build datasets for simpleT5

```bash
bash run.sh build_t5_all -f bio.yaml -e 'ner.*'
```

## Topic tasks

```bash
bash run.sh topic -t esg_topic_test_00_model
bash run.sh topic -t esg_topic_test_10_infer_agg
bash run.sh topic -t esg_topic_test_20_corpus_task
bash run.sh topic -t esg_topic_test_30_sampling
```

## Finetune a simple classification model

```bash
bash run.sh finetune -t simple_classification -c esg_topics 
```