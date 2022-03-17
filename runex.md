# Examples

## Corpus tasks

```bash
bash data/ekorpkit-config/run.sh corpus -t corpus_sample c nikl_news 

bash data/ekorpkit-config/run.sh corpus -t corpus_sample -c aihub_book
```

## Build corpus

```bash
bash data/ekorpkit-config/run.sh build_corpus -c aihub_book
```

## Topic tasks

```bash
bash data/ekorpkit-config/run.sh topic -t esg_topic_test_00_model
bash data/ekorpkit-config/run.sh topic -t esg_topic_test_10_infer_agg
bash data/ekorpkit-config/run.sh topic -t esg_topic_test_20_corpus_task
bash data/ekorpkit-config/run.sh topic -t esg_topic_test_30_sampling
```