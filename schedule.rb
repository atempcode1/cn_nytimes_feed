set :output, "$PENG_PATH/log/cron.log"
every 3.hours do
    command "cd $PENG_PATH && ruby script/spider.rb"
end
