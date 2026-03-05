# Unit test file
import pytest
from unittest.mock import patch
from app import app


@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


class TestSubmitFeedback:
    def test_submit_feedback_success(self, client):
        payload = {'name': 'Alice', 'category': 'General Enquiry', 'message': 'Hello there!'}
        response = client.post('/submit-feedback', json=payload)
        assert response.status_code == 200
        data = response.get_json()
        assert data['status'] == 'success'

    def test_submit_feedback_logs_message(self, client):
        payload = {'name': 'Bob', 'category': 'Billing', 'message': 'I have a billing question.'}
        with patch('app.logger') as mock_logger:
            response = client.post('/submit-feedback', json=payload)
            assert response.status_code == 200
            mock_logger.info.assert_called_once()
            call_args = mock_logger.info.call_args
            assert 'Bob' in str(call_args)
            assert 'Billing' in str(call_args)
            assert 'I have a billing question.' in str(call_args)

    def test_submit_feedback_missing_name(self, client):
        payload = {'category': 'General Enquiry', 'message': 'Hello'}
        response = client.post('/submit-feedback', json=payload)
        assert response.status_code == 400

    def test_submit_feedback_missing_category(self, client):
        payload = {'name': 'Alice', 'message': 'Hello'}
        response = client.post('/submit-feedback', json=payload)
        assert response.status_code == 400

    def test_submit_feedback_missing_message(self, client):
        payload = {'name': 'Alice', 'category': 'Other'}
        response = client.post('/submit-feedback', json=payload)
        assert response.status_code == 400

    def test_submit_feedback_no_body(self, client):
        response = client.post('/submit-feedback', data='', content_type='application/json')
        assert response.status_code == 400
