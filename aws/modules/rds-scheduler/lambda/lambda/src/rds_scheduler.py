import boto3
import logging

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_rds_client():
    """Create and return an RDS client."""
    return boto3.client('rds')

def get_db_instance_status(rds_client, db_instance_id):
    """Get the current status of the RDS instance."""
    try:
        response = rds_client.describe_db_instances(DBInstanceIdentifier=db_instance_id)
        return response['DBInstances'][0]['DBInstanceStatus']
    except Exception as e:
        logger.error(f"Error getting DB instance status: {str(e)}")
        raise

def start_rds_instance(rds_client, db_instance_id):
    """Start the RDS instance."""
    try:
        current_status = get_db_instance_status(rds_client, db_instance_id)
        if current_status == 'stopped':
            logger.info(f"Starting RDS instance: {db_instance_id}")
            rds_client.start_db_instance(DBInstanceIdentifier=db_instance_id)
            logger.info(f"Successfully initiated start of RDS instance: {db_instance_id}")
        else:
            logger.info(f"RDS instance {db_instance_id} is already running or in a different state: {current_status}")
    except Exception as e:
        logger.error(f"Error starting RDS instance: {str(e)}")
        raise

def stop_rds_instance(rds_client, db_instance_id):
    """Stop the RDS instance."""
    try:
        current_status = get_db_instance_status(rds_client, db_instance_id)
        if current_status == 'available':
            logger.info(f"Stopping RDS instance: {db_instance_id}")
            rds_client.stop_db_instance(DBInstanceIdentifier=db_instance_id)
            logger.info(f"Successfully initiated stop of RDS instance: {db_instance_id}")
        else:
            logger.info(f"RDS instance {db_instance_id} is already stopped or in a different state: {current_status}")
    except Exception as e:
        logger.error(f"Error stopping RDS instance: {str(e)}")
        raise

def lambda_handler(event, context):
    """
    Lambda handler function that starts or stops RDS instances based on the event.
    
    Expected event format:
    {
        "action": "start" or "stop",
        "db_instance_id": "your-db-instance-id"
    }
    """
    try:
        # Get the action and DB instance ID from the event
        action = event.get('action')
        db_instance_id = event.get('db_instance_id')
        
        if not action or not db_instance_id:
            raise ValueError("Both 'action' and 'db_instance_id' must be provided in the event")
        
        # Get RDS client
        rds_client = get_rds_client()
        
        # Perform the requested action
        if action.lower() == 'start':
            start_rds_instance(rds_client, db_instance_id)
        elif action.lower() == 'stop':
            stop_rds_instance(rds_client, db_instance_id)
        else:
            raise ValueError(f"Invalid action: {action}. Must be either 'start' or 'stop'")
        
        return {
            'statusCode': 200,
            'body': f"Successfully {action}ed RDS instance {db_instance_id}"
        }
        
    except Exception as e:
        logger.error(f"Error in lambda_handler: {str(e)}")
        raise 