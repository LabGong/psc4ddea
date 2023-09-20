function [keys_out, values_out] = zget_nb(dict,key,nb_range)

% 1. ���÷�����
%   [keys_nb, values_nb] = zget_all(hash_table,key,nb_range)
% 2. ����
%   ditc����ϣ��key��λ��������nb_range����Ӧkey��ά������Χ����
%         Ҫ��key��nb_range�Լ���ϣ����key�����е�Ԫ��������ȣ��������ʧ�ܣ���ʾ��ʾ��Ϣ
% 3. ����ֵ
%   keys_out��cell���ͣ�����ÿ��Ԫ����һ��λ������
%             ʹ�÷�����keys_out{i}ȡ����i��λ������
%                     keys_out{i}(j)ȡ����i��λ�������ĵ�j������
%   values_out��cell���ͣ�����ÿ��Ԫ����һ����Ӧֵ(double)
%               ʹ�÷�����values_out{i}ȡ����i����Ӧֵ

keys_nb = cell(1,1);
values_nb = cell(1,1);

len_key = size(key, 2);
len_range = size(nb_range, 2);

if len_key ~= len_range
    display('ERROR: zget_nb calling! -- Length of "key" and "nb_range" not equal!');
    keys_out = keys_nb;
values_out = values_nb;
    return;
end

[keys, values] = zget_all(dict);

len_keys = numel(keys);
if len_keys <= 0
    keys_out = keys_nb;
    values_out = values_nb;
    return;
end

len_keys_in_cell = numel(str2num(str2mat(keys(1))));
if len_keys_in_cell ~= len_range
    display('ERROR: zget_nb calling! -- Length of "key" is not equals to keys in hash!');
    keys_out = keys_nb;
values_out = values_nb;
    return;
end

nb_cur_index = 1;
for i = 1:len_keys
    key_nb = str2num(str2mat(keys(i)));
    for j = 1:len_key
        diff = abs(key_nb(j) - key(j));
        if diff > nb_range(j)
            break;
        end
    end
    if j >= len_key
        keys_nb{nb_cur_index} = key_nb;
        values_nb{nb_cur_index} = values(i);
        nb_cur_index = nb_cur_index + 1;
    end
end

keys_out = keys_nb;
values_out = values_nb;