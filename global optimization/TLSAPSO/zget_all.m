function [keys_out, values_out] = zget_all(dict)

% 1. ���÷�����
%   [keys_out, values_out] = zget_all(hash_table)
% 2. ����
%   ditc����ϣ��
% 3. ����ֵ
%   keys_out��cell���ͣ�����ÿ��Ԫ����һ��λ������
%             ʹ�÷�����str2num(str2mat(keys_out(i)))ȡ����i��λ������
%   values_out���������ͣ�����ÿ��Ԫ����һ����Ӧֵ(double)
%               ʹ�÷�����values_out(i)ȡ����i����Ӧֵ

keys = cell(dict.size,1);
values = zeros(dict.size,1);

e = dict.keys();
i = 1; 
while e.hasMoreElements()
    keys{i} = e.nextElement();
    values(i) = dict.get(keys{i});
    i = i + 1;
end

keys_out = keys;
values_out = values;