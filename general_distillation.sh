#bin/bash/
# ${BERT_BASE_DIR}$ includes the BERT-base teacher model.
export CORPUS_RAW="data.txt"
export BERT_BASE_DIR=bert
export CORPUS_JSON_DIR=train_json
python3 pregenerate_training_data.py --train_corpus ${CORPUS_RAW} \
    --bert_model ${BERT_BASE_DIR} \
    --reduce_memory --do_lower_case \
    --epochs_to_generate 3 \
    --output_dir ${CORPUS_JSON_DIR} 

# ${STUDENT_CONFIG_DIR}$ includes the config file of student_model.
export GENERAL_TINYBERT_DIR="general_tiny"
export STUDENT_CONFIG_DIR="L4_H312"
python3 general_distill.py --pregenerated_data ${CORPUS_JSON_DIR} \
    --teacher_model ${BERT_BASE_DIR} \
    --student_model ${STUDENT_CONFIG_DIR} \
    --reduce_memory --do_lower_case \
    --train_batch_size 4 \
    --output_dir ${GENERAL_TINYBERT_DIR} 