class Api::V1::JobsController < ApplicationController
  include AuthenticatedController

  # Get Sidekiq queue statistics
  def stats
    stats = {
      processed: Sidekiq::Stats.new.processed,
      failed: Sidekiq::Stats.new.failed,
      enqueued: Sidekiq::Stats.new.enqueued,
      queues: Sidekiq::Stats.new.queues,
      workers_size: Sidekiq::Stats.new.workers_size,
      processes_size: Sidekiq::Stats.new.processes_size
    }

    render json: { stats: stats }, status: :ok
  rescue => e
    render json: { error: "Failed to get job stats: #{e.message}" }, status: :internal_server_error
  end

  # Get jobs in queue
  def queue
    queue_name = params[:queue] || 'default'
    queue = Sidekiq::Queue.new(queue_name)
    
    jobs = queue.map do |job|
      {
        jid: job.jid,
        class: job.klass,
        args: job.args,
        created_at: job.created_at,
        enqueued_at: job.enqueued_at
      }
    end

    render json: {
      queue: queue_name,
      size: queue.size,
      jobs: jobs
    }, status: :ok
  rescue => e
    render json: { error: "Failed to get queue: #{e.message}" }, status: :internal_server_error
  end

  # Test job execution - manually trigger a test job
  def test
    # Use ReceiptProcessorWorker as a test since it's already set up
    test_data = {
      'event' => 'status_changed',
      'expense_id' => params[:expense_id] || 0,
      'meta' => {
        'from' => 'test',
        'to' => 'test',
        'test' => true,
        'timestamp' => Time.current.to_i
      }
    }
    
    job_id = ReceiptProcessorWorker.perform_async(test_data)
    
    render json: {
      message: "Test job enqueued successfully",
      job_id: job_id,
      status: "queued",
      test_data: test_data
    }, status: :ok
  rescue => e
    render json: { error: "Failed to enqueue test job: #{e.message}" }, status: :internal_server_error
  end

  # Get failed jobs
  def failed
    failed_jobs = Sidekiq::RetrySet.new.map do |job|
      {
        jid: job.jid,
        class: job.klass,
        args: job.args,
        error_class: job.item['error_class'],
        error_message: job.item['error_message'],
        failed_at: job.item['failed_at'],
        retry_count: job.item['retry_count']
      }
    end

    render json: {
      failed_count: Sidekiq::RetrySet.new.size,
      jobs: failed_jobs
    }, status: :ok
  rescue => e
    render json: { error: "Failed to get failed jobs: #{e.message}" }, status: :internal_server_error
  end
end
