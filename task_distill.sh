#bin/bash
#Data Augmentation

export BERT_BASE_DIR=bert
export GLOVE_EMB=glove.42B.300d.txt
export GLUE_DIR=glue_data
export TASK_NAME=STS-B
python3 data_augmentation.py --pretrained_bert_model ${BERT_BASE_DIR} \
                            --glove_embs ${GLOVE_EMB} \
                            --glue_dir ${GLUE_DIR} \
                            --task_name ${TASK_NAME} \
                            --N 1
#Task-specific Distillation

# ${FT_BERT_BASE_DIR}$ contains the fine-tuned BERT-base model.
#  intermediate layer distillation.
export FT_BERT_BASE_DIR=bert
export GENERAL_TINYBERT_DIR=general_tiny
export TASK_DIR=glue_data
export TASK_NAME=STS-B
export TMP_TINYBERT_DIR=temp_tinybert
python3 task_distill.py --teacher_model ${FT_BERT_BASE_DIR} \
                       --student_model ${GENERAL_TINYBERT_DIR} \
                       --data_dir ${TASK_DIR} \
                       --task_name ${TASK_NAME} \
                       --output_dir ${TMP_TINYBERT_DIR} \
                       --max_seq_length 128 \
                       --train_batch_size 32 \
                       --num_train_epochs 10 \
                       --aug_train \
                       --do_lower_case  

#prediction layer distillation
python3 task_distill.py --pred_distill  \
                       --teacher_model ${FT_BERT_BASE_DIR}$ \
                       --student_model ${TMP_TINYBERT_DIR}$ \
                       --data_dir ${TASK_DIR}$ \
                       --task_name ${TASK_NAME}$ \
                       --output_dir ${TINYBERT_DIR}$ \
                       --aug_train  \
                       --do_lower_case \
                       --learning_rate 3e-5  \
                       --num_train_epochs  3  \
                       --eval_step 100 \
                       --max_seq_length 128 \
                       --train_batch_size 32 