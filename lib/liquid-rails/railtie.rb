module Liquid
  module Rails
    class Railtie < ::Rails::Railtie
      config.app_generators.template_engine :liquid

      initializer 'liquid-rails.register_template_handler' do |app|
        ActiveSupport.on_load(:action_view) do
          ActionView::Template.register_template_handler(:liquid, Liquid::Rails::TemplateHandler)
        end
      end

      initializer 'liquid-rails.include_partial' do |app|
	require 'liquid-rails/resolver_system'
        Liquid::Template.file_system = Liquid::Rails::ResolverSystem.new
      end

      initializer 'liquid-rails.setup_drop' do |app|
        [:active_record, :mongoid].each do |orm|
          ActiveSupport.on_load orm do
            Liquid::Rails.setup_drop self
          end
        end
      end
    end
  end
end
