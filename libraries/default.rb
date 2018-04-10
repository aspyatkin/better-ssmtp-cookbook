module ChefCookbook
  module BetterSSMTP
    class Helper
      def initialize(node)
        @node = node
      end

      def mail_send_command(subject, from, to)
        case @node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          %Q(mail -s "#{subject}" -S from="#{from}" #{to})
        when 'debian'
          %Q(mail -s "#{subject}" -a "From: #{from}" #{to})
        else
          %Q(mail -s "#{subject}" -a "From: #{from}" #{to})
        end
      end
    end
  end
end
