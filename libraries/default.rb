module ChefCookbook
  module BetterSSMTP
    class Helper
      def initialize(node)
        @node = node
      end

      def mail_send_command(subject, from, to, suppress_empty_message=false)
        case @node['platform_family']
        when 'rhel', 'fedora', 'amazon'
          %Q(mail #{suppress_empty_message ? '-E ': ''}-s "#{subject}" -S from="#{from}" #{to})
        when 'debian'
          %Q(mail #{suppress_empty_message ? '-E "set nonullbody" ' : ''}-s "#{subject}" -a "From: #{from}" #{to})
        else
          %Q(mail #{suppress_empty_message ? '-E "set nonullbody" ' : ''}-s "#{subject}" -a "From: #{from}" #{to})
        end
      end
    end
  end
end
