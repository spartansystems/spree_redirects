module SpreeRedirects
  # Redirect based on available spree_redirects
  class RedirectMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        status, headers, body = @app.call(env)
      rescue StandardError => e
        routing_error = e
      end

      return new_response(env) if routing_error.present? || status == 404

      # Raises errors in Dev mode where `consider_all_requests_local` is true
      fail routing_error if routing_error.present?

      [status, headers, body]
    end

    def new_response(env)
      url = find_redirect(env['PATH_INFO'])
      [
        301,
        { 'Location' => generate_url(url, env['QUERY_STRING']) },
        ['Redirecting...']
      ]
    end

    def generate_url(url, query_string)
      redirect_url = [url, query_string]
                     .join('?')
                     .sub(%r{[\/\?\s]*$}, '')
                     .strip
      redirect_url.presence || '/'
    end

    def find_redirect(url)
      redirect = Spree::Redirect.find_by_old_url(url)
      redirect.new_url unless redirect.nil?
    end
  end
end
