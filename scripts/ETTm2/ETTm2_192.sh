#!/bin/bash


mkdir -p ./logs/LongForecasting/ETTm2


export CUDA_VISIBLE_DEVICES=4

model_name=Leddam
pred_lens=(192)
seq_lens=(96)
bss=(128)
lrs=(1e-4)
dropouts=(0.0)
d_models=(256)

log_dir="./logs/LongForecasting/ETTm2/"

# 迭代各种参数组合
for pred_len in "${pred_lens[@]}"; do
  for seq_len in "${seq_lens[@]}"; do
    for bs in "${bss[@]}"; do
      for lr in "${lrs[@]}"; do
        for dropout in "${dropouts[@]}"; do
          for d_model in "${d_models[@]}"; do
                  cmd="python -u run.py \
                    --task_name long_term_forecast \
                    --is_training 1 \
                    --root_path dataset/ETT-small/ \
                    --data_path ETTm2.csv \
                    --model_id "ETTm2_${seq_len}_${pred_len}" \
                    --model $model_name \
                    --data ETTm2 \
                    --features M \
                    --seq_len $seq_len \
                    --pred_len $pred_len \
                    --batch_size $bs \
                    --learning_rate $lr \
                    --enc_in 7 \
                    --dec_in 7 \
                    --c_out 7 \
                    --des 'Exp' \
                    --n_layers 1\
                    --pe_type sincos\
                    --d_model $d_model\
                    --dropout $dropout\
                    --itr 1 >${log_dir}${seq_len}_${pred_len}_${dropout}_${d_model}_bz${bs}_lr${lr}.log"

                  eval $cmd
          done
        done
      done
    done
  done
done
