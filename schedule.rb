every 3.hours do
  command "bash -l -c 'cd $PENG_PATH && ruby script/spider.rb >> tmp/cron.log'"
end
