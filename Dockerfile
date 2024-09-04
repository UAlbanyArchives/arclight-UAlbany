# Use the base Ruby image
FROM ruby:3.3.4-slim-bookworm

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential apt-utils git cron curl nodejs
# The regular apt install yarn isn't as up to date as we need
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn

# Set working directory
WORKDIR /app

# Install any gems (if needed, this can be done later in the container)
# RUN gem install rails

# Default command
CMD ["bash"]
